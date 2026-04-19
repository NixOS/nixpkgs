{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  __structuredAttrs = true;
  pname = "graphify";
  version = "0.4.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "safishamsi";
    repo = "graphify";
    rev = "v${version}";
    hash = "sha256-QEzB1tFBqGhpmI7oudMRC1Ia0CDcm+GYt6AgxMA5zDo=";
  };

  build-system = [
    python3.pkgs.setuptools
  ];

  dependencies =
    with python3.pkgs;
    [
      networkx
      tree-sitter
    ]
    ++ (with python3.pkgs.tree-sitter-grammars; [
      tree-sitter-c
      tree-sitter-c-sharp
      tree-sitter-cpp
      tree-sitter-elixir
      tree-sitter-go
      tree-sitter-java
      tree-sitter-javascript
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
    all = [
      faster-whisper
      graspologic
      html2text
      matplotlib
      mcp
      neo4j
      openpyxl
      pypdf
      python-docx
      watchdog
      yt-dlp
    ];
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
