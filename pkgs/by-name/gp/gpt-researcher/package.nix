{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gpt-researcher";
  version = "3.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "assafelovic";
    repo = "gpt-researcher";
    rev = "v${version}";
    hash = "sha256-XCSZrN8pmiNg14umqOAR0zRHvVdQAN/symeYIlDOB4c=";
  };

  build-system = [
    python3.pkgs.poetry-core
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
    sqlalchemy
    tavily-python
    tiktoken
    unstructured
    uvicorn
  ];

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
