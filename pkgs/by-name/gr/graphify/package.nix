{
  lib,
  python3Packages,
  fetchFromGitHub,
  python3,
}:

python3Packages.buildPythonApplication rec {
  __structuredAttrs = true;
  # official PyPI package name is 'graphifyy', here it is renamed to be in sync with CLI binary name
  pname = "graphify";
  version = "0.8.46";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "safishamsi";
    repo = "graphify";
    tag = "v${version}";
    hash = "sha256-L+bno9hKc4cRbAgfgI0LltiYgQcnArV5h7eWCSmqnek=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  # existing grammar differ from github:amaanq/tree-sitter-groovy
  pythonRemoveDeps = [ "tree-sitter-groovy" ];
  dependencies =
    with python3.pkgs;
    [
      # keep-sorted start
      networkx
      numpy
      rapidfuzz
      tree-sitter
      # keep-sorted end
    ]
    ++ (with python3.pkgs.tree-sitter-grammars; [
      # keep-sorted start
      tree-sitter-bash
      tree-sitter-c
      tree-sitter-c-sharp
      tree-sitter-cpp
      tree-sitter-elixir
      tree-sitter-fortran
      tree-sitter-go
      # tree-sitter-groovy
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
      # keep-sorted end
    ]);

  optional-dependencies = with python3.pkgs; {
    leiden = [
      graspologic
    ];
    mcp = [
      mcp
    ];
    neo4j = [
      neo4j
    ];
    office = [
      openpyxl
      python-docx
    ];
    pdf = [
      html2text
      pypdf
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

  meta = {
    description = "AI coding assistant skill. Turn any folder of code, docs, papers, images, or videos into a queryable knowledge graph.";
    homepage = "https://github.com/safishamsi/graphify";
    changelog = "https://github.com/safishamsi/graphify/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stunkymonkey ];
    mainProgram = "graphify";
  };
}
