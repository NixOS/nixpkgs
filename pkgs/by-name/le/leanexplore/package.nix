{
  lib,
  python3,
  fetchFromGitHub,
  callPackage,
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
    sqlalchemy
    numpy
    faiss
    sentence-transformers
    httpx
    pydantic
    typer
    openai
    nltk
    rank-bm25
    toml
    mcp
    (callPackage ../../op/openai-agents/package.nix {})
  ];

  # Disable runtime dependencies check due to missing openai-agents package
  dontCheckRuntimeDeps = true;

  # Tests require network access and specific data
  doCheck = false;

  meta = {
    description = "A search engine for Lean 4 declarations with MCP server support";
    longDescription = ''
      LeanExplore is a search engine for Lean 4 declarations that provides semantic search
      capabilities across Lean codebases. It includes a Model Context Protocol (MCP) server
      implementation that exposes LeanExplore's functionalities as tools consumable by 
      external AI agent systems, enabling programmatic interaction for tasks like automated
      theorem proving or AI-driven mathematical research.
    '';
    homepage = "https://github.com/justincasher/lean-explore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "leanexplore";
  };
}