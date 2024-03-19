{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "strictdoc";
  version = "0.0.40";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strictdoc-project";
    repo = "strictdoc";
    rev = "refs/tags/${version}";
    hash = "sha256-kZ8qVhroSPSGAcgUFZb1vRI6JoFyjeg/0qYosbRnwyc=";
  };

  pythonRelaxDeps = true;

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    datauri
    docutils
    fastapi
    html5lib
    jinja2
    lxml
    markupsafe
    pybtex
    pygments
    python-multipart
    reqif
    selenium
    setuptools
    spdx-tools
    textx
    toml
    uvicorn
    webdriver-manager
    websockets
    xlrd
    xlsxwriter
  ] ++ uvicorn.optional-dependencies.standard;

  nativeCheckInputs = with python3.pkgs; [
    httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "strictdoc"
  ];

  disabledTests = [
    # fixture 'fs' not found
    "test_001_load_from_files"
  ];

  disabledTestPaths = [
    "tests/end2end/"
  ];

  meta = with lib; {
    description = "Software requirements specification tool";
    mainProgram = "strictdoc";
    homepage = "https://github.com/strictdoc-project/strictdoc";
    changelog = "https://github.com/strictdoc-project/strictdoc/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ yuu ];
  };
}
