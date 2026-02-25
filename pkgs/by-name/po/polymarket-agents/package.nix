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
