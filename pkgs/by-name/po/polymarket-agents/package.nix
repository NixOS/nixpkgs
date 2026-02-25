{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication {
  pname = "polymarket-agents";
  version = "0-unstable-2024-11-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Polymarket";
    repo = "agents";
    rev = "081f2b5594c37edeb9d3780a778c084d5b6f2743";
    hash = "sha256-nzn3+S//ShotGJbIjR7zg62lH38dyLQ7uPUbJEpPSpY=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    chromadb
    devtools
    fastapi
    httpx
    langchain
    langchain-chroma
    langchain-community
    langchain-openai
    langgraph
    newsapi-python
    openai
    py-clob-client
    py-order-utils
    pydantic
    python-dotenv
    requests
    scheduler
    tavily-python
    typer
    uvicorn
    web3
  ];

  pythonRelaxDeps = true;

  postPatch = ''
    # Patch web3 v7 compatibility: geth_poa_middleware was renamed
    substituteInPlace agents/polymarket/polymarket.py \
      --replace-fail "from web3.middleware import geth_poa_middleware" \
                     "from web3.middleware import ExtraDataToPOAMiddleware" \
      --replace-fail "self.web3.middleware_onion.inject(geth_poa_middleware, layer=0)" \
                     "self.web3.middleware_onion.inject(ExtraDataToPOAMiddleware, layer=0)"

    # Defer client initialization so --help works without API keys
    cat > scripts/python/cli.py << 'CLIPATCH'
    import typer
    from devtools import pprint

    app = typer.Typer()


    def _get_polymarket():
        from agents.polymarket.polymarket import Polymarket
        return Polymarket()


    def _get_news():
        from agents.connectors.news import News
        return News()


    def _get_rag():
        from agents.connectors.chroma import PolymarketRAG
        return PolymarketRAG()


    @app.command()
    def get_all_markets(limit: int = 5, sort_by: str = "spread") -> None:
        """Query Polymarket's markets"""
        polymarket = _get_polymarket()
        markets = polymarket.get_all_markets()
        markets = polymarket.filter_markets_for_trading(markets)
        if sort_by == "spread":
            markets = sorted(markets, key=lambda x: x.spread, reverse=True)
        markets = markets[:limit]
        pprint(markets)


    @app.command()
    def get_relevant_news(keywords: str) -> None:
        """Use NewsAPI to query the internet"""
        newsapi_client = _get_news()
        articles = newsapi_client.get_articles_for_cli_keywords(keywords)
        pprint(articles)


    @app.command()
    def get_all_events(limit: int = 5, sort_by: str = "number_of_markets") -> None:
        """Query Polymarket's events"""
        polymarket = _get_polymarket()
        events = polymarket.get_all_events()
        events = polymarket.filter_events_for_trading(events)
        if sort_by == "number_of_markets":
            events = sorted(events, key=lambda x: len(x.markets), reverse=True)
        events = events[:limit]
        pprint(events)


    @app.command()
    def create_local_markets_rag(local_directory: str) -> None:
        """Create a local markets database for RAG"""
        polymarket_rag = _get_rag()
        polymarket_rag.create_local_markets_rag(local_directory=local_directory)


    @app.command()
    def query_local_markets_rag(vector_db_directory: str, query: str) -> None:
        """RAG over a local database of Polymarket's events"""
        polymarket_rag = _get_rag()
        response = polymarket_rag.query_local_markets_rag(
            local_directory=vector_db_directory, query=query
        )
        pprint(response)


    @app.command()
    def ask_superforecaster(event_title: str, market_question: str, outcome: str) -> None:
        """Ask a superforecaster about a trade"""
        from agents.application.executor import Executor
        executor = Executor()
        response = executor.get_superforecast(
            event_title=event_title, market_question=market_question, outcome=outcome
        )
        print(f"Response:{response}")


    @app.command()
    def create_market() -> None:
        """Format a request to create a market on Polymarket"""
        from agents.application.creator import Creator
        c = Creator()
        market_description = c.one_best_market()
        print(f"market_description: str = {market_description}")


    @app.command()
    def ask_llm(user_input: str) -> None:
        """Ask a question to the LLM and get a response."""
        from agents.application.executor import Executor
        executor = Executor()
        response = executor.get_llm_response(user_input)
        print(f"LLM Response: {response}")


    @app.command()
    def ask_polymarket_llm(user_input: str) -> None:
        """What types of markets do you want trade?"""
        from agents.application.executor import Executor
        executor = Executor()
        response = executor.get_polymarket_llm(user_input=user_input)
        print(f"LLM + current markets&events response: {response}")


    @app.command()
    def run_autonomous_trader() -> None:
        """Let an autonomous system trade for you."""
        from agents.application.trade import Trader
        trader = Trader()
        trader.one_best_trade()


    if __name__ == "__main__":
        app()
    CLIPATCH
  '';

  preBuild = ''
    # Create __init__.py files for implicit namespace packages
    touch agents/__init__.py
    touch agents/application/__init__.py
    touch agents/connectors/__init__.py
    touch agents/polymarket/__init__.py
    touch agents/utils/__init__.py

    # Synthesize setup.py since the project has no standard packaging
    cat > setup.py << 'SETUP'
    from setuptools import setup, find_packages

    setup(
      name='polymarket-agents',
      version='0.0.0',
      packages=find_packages(),
      entry_points={
        'console_scripts': ['polymarket-agents=scripts.python.cli:app']
      },
    )
    SETUP

    # Create __init__.py for scripts packages
    touch scripts/__init__.py
    touch scripts/python/__init__.py
  '';

  # Tests require API keys and network access
  doCheck = false;

  pythonImportsCheck = [
    "agents"
    "agents.polymarket"
    "agents.application"
    "agents.connectors"
    "agents.utils"
  ];

  meta = {
    description = "AI-powered autonomous trading agents for Polymarket prediction markets";
    homepage = "https://github.com/Polymarket/agents";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "polymarket-agents";
  };
}
