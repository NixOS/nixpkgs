{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "strictdoc";
  version = "0.27.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "strictdoc";
    tag = finalAttrs.version;
    hash = "sha256-z9e/ZkKeiuNgkn0FoAYX2fxo60TH5hqsLRzpaVvS2u4=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    python-datauri
    docutils
    fastapi
    graphviz
    html2pdf4doc
    html5lib
    jinja2
    lark
    lxml
    markdown-it-py
    openpyxl
    orjson
    pandas
    plotly
    pybtex
    pygments
    python-multipart
    reqif
    requests
    robotframework
    selenium
    setuptools
    spdx-tools
    textx
    toml
    tree-sitter
    tree-sitter-grammars.tree-sitter-c
    tree-sitter-grammars.tree-sitter-cpp
    tree-sitter-grammars.tree-sitter-python
    tree-sitter-grammars.tree-sitter-rust
    uvicorn
    watchdog
    webdriver-manager
    websockets
    xlrd
    xlsxwriter
  ];

  optional-dependencies = with python3.pkgs; {
    development = [
      invoke
      tox
    ];
    nuitka = [
      nuitka
      ordered-set
    ];
  };

  pythonRelaxDeps = [
    "python-datauri"
    "xlsxwriter"
  ];

  pythonImportsCheck = [ "strictdoc" ];

  meta = {
    description = "Software for technical documentation and requirements management";
    homepage = "https://github.com/strictdoc-project/strictdoc";
    changelog = "https://github.com/strictdoc-project/strictdoc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      dadada
      puzzlewolf
    ];
    mainProgram = "strictdoc";
  };
})
