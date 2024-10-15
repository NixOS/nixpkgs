{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "strictdoc";
  version = "0.0.58";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "strictdoc";
    rev = "refs/tags/${version}";
    hash = "sha256-0X74Lv25pUdOUgQzqQU6p+fjuxhC/JqfKEFI7c5t67U=";
  };

  nativeBuildInputs = [
    python3.pkgs.hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    docutils
    fastapi
    graphviz
    html5lib
    jinja2
    lxml
    pybtex
    pygments
    datauri
    python-multipart
    selenium
    requests
    spdx-tools
    webdriver-manager
    reqif
    setuptools
    textx
    toml
    uvicorn
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

  meta = with lib; {
    description = "Software for technical documentation and requirements management";
    homepage = "https://github.com/strictdoc-project/strictdoc";
    changelog = "https://github.com/strictdoc-project/strictdoc/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
    mainProgram = "strictdoc";
  };
}
