# Wall St. Lab/Brokerage Page
# 1. Client has many portfolios (portfolio belongs to client)
# 2. Portfolio has and belong to many (habtm) stocks
# 3. Stocks habtm portfolios
###############
# 4. Bonus: add a page that shows all the stocks in the database and who they belong to.
###############
# 5. Bonus 2:  use stock gem (yahoo finance) to list stock prices
########################

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'


ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :host => 'localhost',
  :username => 'tomgalpin',
  :password => '',
  :database => 'wdi_brokerage',
  :encoding => 'utf8'
)

require_relative "client"
require_relative "stock"
require_relative "portfolio"

############ Index
get "/" do
  @clients = Client.all
  erb :index
end

############ new_client
get "/new_client" do
  erb :new_client
end

post "/new_client" do
  @client = Client.new(params[:client])

  if @client.save
    @portfolio = Portfolio.create(params[:portfolio])
    @client.update_attributes(:portfolio_id => @portfolio.id)
    redirect "/"
  else
    erb :new_client
  end
end

############ new_portfolio
get "/new_portfolio" do
  erb: new_portfolio
end

post "/new_portfolio" do
  #portfolio doesn't have a port. name; just id.; not sure if this works.
  @portfolio = Portfolio.new(:name => params[:portfolio_id])
  if @portfolio.save
    redirect "/"
  else
    erb :new_portfolio
  end
end

############ new_stock
get "/new_stock" do
  erb :new_stock
end

post "/new_stock" do
  @stock = Stock.new(params[:stock])

  if @stock.save
    redirect "/"
  else
    erb :new_stock
  end
end

############ edit_client & edit_portfolio
get "/edit_client/:client_id" do
  @client = Client.find_by_id(params[:client_id])
  erb :edit_client
end

get "/edit_portfolio/:portfolio_id" do
  @portfolio = Portfolio.find_by_id(params[:portfolio_id])
  erb :edit_portfolio
end

############ save_client & new_portfolio & new_stock********************
post "/save_client/:client_id" do
  @client = Client.find_by_id(params[:client_id])

  if @client.update_attributes(params[:client])
    redirec "/"
  else
    erb :edit_client
  end
end

post "/save_portfolio/:portfolio_id" do
  @portfolio = Porfolio.find_by_id(params[:portfolio_id])

  if @portfolio.update_attributes(params[:portfolio])
    redirect "/"
  else
    erb :edit_portfolio
  end
end

post "/save_stock/:stock_id" do
  @stock = Stock.find_by_id(params[:stock_id])

  if @stock.update_attributes(params[:stock])
    redirect "/"
  else
    erb :edit_stock
  end
end

















