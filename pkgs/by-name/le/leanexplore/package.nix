{
  lib,
  python3,
  fetchFromGitHub,
  callPackage,
  makeWrapper,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lean-explore";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "justincasher";
    repo = "lean-explore";
    rev = "v${version}";
    hash = "sha256-tXKfl9Itkr21pRsBkAXt40vSrOYOFNvL+O+dhOjxrSQ=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    faiss
    httpx
    mcp
    nltk
    numpy
    openai
    openai-agents
    pydantic
    rank-bm25
    sentence-transformers
    sqlalchemy
    toml
    typer
  ];
  dontCheckRuntimeDeps = true;
  nativeBuildInputs = [ makeWrapper ];

  pythonImportsCheck = [ "lean_explore" ];

  postInstall = ''
    # Wrap the leanexplore command to ensure subprocesses have the correct PYTHONPATH
    wrapProgram $out/bin/leanexplore \
      --set PYTHONPATH "$PYTHONPATH"
  '';

  meta = {
    description = "A search engine for Lean 4 declarations with MCP server support";
    longDescription = ''
      LeanExplore is a search engine for Lean 4 declarations that provides semantic search
      capabilities across Lean codebases. It includes a Model Context Protocol (MCP) server
      implementation that exposes LeanExplore's functionalities as tools consumable by 
      external AI agent systems, enabling programmatic interaction for tasks like automated
      theorem proving or AI-driven mathematical research. 

      Launch a local `leanexplore` MCP server with:

      ```bash
      leanexplore mcp serve --api-key $YOUR_LEANEXPLORE_API_KEY
      ```
    '';
    homepage = "https://github.com/justincasher/lean-explore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wvhulle ];
    mainProgram = "leanexplore";
  };
}
