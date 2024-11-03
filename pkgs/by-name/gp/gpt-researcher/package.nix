{ lib
, python3
, fetchFromGitHub
, nodejs
, mkYarnModules
}:

let
  frontendDeps = mkYarnModules {
    pname = "gpt-researcher-frontend-deps";
    version = "3.1.3";
    packageJSON = ./frontend/package.json;
    yarnLock = ./frontend/yarn.lock;
    yarnNix = ./frontend/yarn.nix;
  };
in

python3.pkgs.buildPythonApplication rec {
  pname = "gpt-researcher";
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "assafelovic";
    repo = "gpt-researcher";
    rev = "v${version}";
    hash = "sha256-gVheOn0c+ua9KY3RWI7tgZ4+oobwR+Mh/HDd014l8Po=";
  };

  build-system = [
    python3.pkgs.poetry-core
  ];

  nativeBuildInputs = [
    nodejs
  ];

  dependencies = with python3.pkgs; [
    aiofiles
    arxiv
    beautifulsoup4
    colorama
    duckduckgo-search
    fastapi
    htmldocx
    jinja2
    langchain
    langchain-community
    langchain-openai
    langgraph
    lxml
    markdown
    md2pdf
    mistune
    openai
    permchain
    pydantic
    pymupdf
    python-docx
    python-dotenv
    python-multipart
    pyyaml
    requests
    selenium
    sqlalchemy
    tavily-python
    tiktoken
    unstructured
    uvicorn
    webdriver-manager
  ];

  preBuild = ''
    ln -s ${frontendDeps}/node_modules frontend/node_modules
    cd frontend
    npm run build
    cd ..
    mkdir -p gpt_researcher/static
    cp -r frontend/dist/* gpt_researcher/static/
  '';

  pythonImportsCheck = [
    "gpt_researcher"
  ];

  meta = {
    description = "LLM based autonomous agent that does online comprehensive research on any given topic";
    homepage = "https://github.com/assafelovic/gpt-researcher";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "gpt-researcher";
  };
}
