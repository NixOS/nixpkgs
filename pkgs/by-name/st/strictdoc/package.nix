{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "strictdoc";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "strictdoc";
    tag = version;
    hash = "sha256-TXrSv6V5fMhcx4YolTfsFwgGL5qxNp67iv62KDC5H00=";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    datauri
    docutils
    fastapi
    graphviz
    html2pdf4doc
    html5lib
    jinja2
    lark
    lxml
    openpyxl
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
    tree-sitter-grammars.tree-sitter-cpp
    tree-sitter-grammars.tree-sitter-python
    uvicorn
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
    changelog = "https://github.com/strictdoc-project/strictdoc/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "strictdoc";
  };
}
