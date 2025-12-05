{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "refurb";
  version = "2.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "dosisod";
    repo = "refurb";
    tag = "v${version}";
    hash = "sha256-Y401oUQd516Pyf+8sTrje5AoeWCSGKlXktnwyj/nTl8=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    mypy
    mypy-extensions
    tomli
    typing-extensions
  ];

  nativeCheckInputs = with python3Packages; [
    attrs
    click
    colorama
    iniconfig
    mccabe
    packaging
    pathspec
    platformdirs
    pluggy
    py
    pyparsing
    pytest-cov-stub
    pytestCheckHook
  ];

  disabledTests = [
    "test_checks" # broken because new mypy release added new checks
    "test_mypy_consistence" # broken by new mypy release
  ];

  pythonImportsCheck = [
    "refurb"
  ];

  meta = with lib; {
    description = "Tool for refurbishing and modernizing Python codebases";
    mainProgram = "refurb";
    homepage = "https://github.com/dosisod/refurb";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ knl ];
  };
}
