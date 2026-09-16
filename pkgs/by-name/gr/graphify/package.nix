{
  lib,
  python3Packages,
  fetchFromGitHub,
  python3,
}:

python3Packages.buildPythonApplication rec {
  __structuredAttrs = true;
  pname = "graphify";
  version = "0.9.53";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Graphify-Labs";
    repo = "graphify";
    tag = "v${version}";
    hash = "sha256-1G8PuSxYM70nMf8glJARA9vVMI8Ue7zqfAxgXi18lPM=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  # The bindings in python3Packages.tree-sitter-grammars track the grammar
  # repos, whose versions drift from the pins upstream declares.
  pythonRelaxDeps = [
    "tree-sitter-fortran"
    "tree-sitter-groovy"
    "tree-sitter-julia"
    "tree-sitter-kotlin"
  ];

  dependencies =
    with python3.pkgs;
    [
      networkx
      numpy
      rapidfuzz
      tree-sitter
    ]
    ++ (with python3.pkgs.tree-sitter-grammars; [
      tree-sitter-bash
      tree-sitter-c
      tree-sitter-c-sharp
      tree-sitter-cpp
      tree-sitter-elixir
      tree-sitter-fortran
      tree-sitter-go
      tree-sitter-groovy
      tree-sitter-java
      tree-sitter-javascript
      tree-sitter-json
      tree-sitter-julia
      tree-sitter-kotlin
      tree-sitter-lua
      tree-sitter-objc
      tree-sitter-php
      tree-sitter-powershell
      tree-sitter-python
      tree-sitter-ruby
      tree-sitter-rust
      tree-sitter-scala
      tree-sitter-swift
      tree-sitter-typescript
      tree-sitter-verilog
      tree-sitter-zig
    ]);

  optional-dependencies = with python3.pkgs; {
    anthropic = [
      anthropic
    ];
    bedrock = [
      boto3
    ];
    chinese = [
      jieba
    ];
    commonlisp = [
      tree-sitter-grammars.tree-sitter-commonlisp
    ];
    leiden = [
      graspologic
    ];
    mcp = [
      mcp
      starlette
    ];
    neo4j = [
      neo4j
    ];
    office = [
      openpyxl
      python-docx
    ];
    openai = [
      openai
      tiktoken
    ];
    pdf = [
      markdownify
      pypdf
    ];
    postgres = [
      psycopg
    ];
    svg = [
      matplotlib
    ];
    video = [
      faster-whisper
      yt-dlp
    ];
    watch = [
      watchdog
    ];
  };

  pythonImportsCheck = [ "graphify" ];

  # The attribute and the command are `graphify`, but upstream publishes the
  # distribution as `graphifyy`. pythonMetadataCheckPhase resolves the
  # distribution by `pname`, so it cannot find it:
  #   nix-build -E 'with import ./. {};
  #     python3.withPackages (_: [ (python3.pkgs.toPythonModule graphify) ])'
  #   => PackageNotFoundError: No package metadata was found for graphify
  dontCheckPythonMetadata = true;

  meta = {
    description = "AI coding assistant skill. Turn any folder of code, docs, papers, images, or videos into a queryable knowledge graph.";
    homepage = "https://github.com/Graphify-Labs/graphify";
    changelog = "https://github.com/Graphify-Labs/graphify/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ stunkymonkey ];
    mainProgram = "graphify";
  };
}
