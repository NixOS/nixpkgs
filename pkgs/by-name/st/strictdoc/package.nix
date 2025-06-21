{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "strictdoc";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "strictdoc";
    tag = version;
    hash = "sha256-hT7QlJZRilC7GeX96mS2g99rvKYmiO+09AZ/IZL+S/o=";
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
    # This software is licensed under the Apache License, Version 2.0
    # when used within the StrictDoc project.
    # https://github.com/mettta/html2pdf4doc_python/blob/04d9f3f1af33e592c168036d8b1b174b35a5872b/LICENSE#L1
    (html2pdf4doc.overrideAttrs (oldAttrs: {
      meta.license = lib.licenses.asl20;
    }))
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
    "lxml"
    "textx"
  ];

  pythonImportsCheck = [ "strictdoc" ];

  meta = {
    description = "Software for technical documentation and requirements management";
    homepage = "https://github.com/strictdoc-project/strictdoc";
    changelog = "https://github.com/strictdoc-project/strictdoc/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yuu ];
    mainProgram = "strictdoc";
  };
}
