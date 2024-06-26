{ bc
, zip
, lib
, fetchFromGitHub
, bats
, buildPythonApplication
, pythonOlder
, callPackage
, kicad
, numpy
, click
, markdown2
, openscad
, pytestCheckHook
, commentjson
, wxpython
, pcbnewtransition
, pybars3
, versioneer
, shapely_1_8
}:
let
  solidpython = callPackage ./solidpython { };
in
buildPythonApplication rec {
  pname = "kikit";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yaqwsx";
    repo = "KiKit";
    rev = "refs/tags/v${version}";
    hash = "sha256-f8FB6EEy9Ch4LcMKd9PADXV9QrSb7e22Ui86G6AnQKE=";
  };

  propagatedBuildInputs = [
    kicad
    numpy
    click
    markdown2
    # OpenSCAD is an optional dependency (see
    # https://github.com/yaqwsx/KiKit/blob/v1.5.0/docs/installation/intro.md#optional-dependencies).
    openscad
    commentjson
    # https://github.com/yaqwsx/KiKit/issues/575
    wxpython
    pcbnewtransition
    pybars3
    # https://github.com/yaqwsx/KiKit/issues/574
    shapely_1_8
    # https://github.com/yaqwsx/KiKit/issues/576
    solidpython
  ];

  nativeBuildInputs = [
    versioneer
    bc
    zip
  ];

  nativeCheckInputs = [
    pytestCheckHook
    bats
  ];

  pythonImportsCheck = [
    "kikit"
  ];

  preCheck = ''
    export PATH=$PATH:$out/bin

    make test-system

    # pytest needs to run in a subdir. See https://github.com/yaqwsx/KiKit/blob/v1.3.0/Makefile#L43
    cd test/units
  '';

  meta = with lib; {
    description = "Automation for KiCAD boards";
    homepage = "https://github.com/yaqwsx/KiKit/";
    changelog = "https://github.com/yaqwsx/KiKit/releases/tag/v${version}";
    maintainers = with maintainers; [ jfly matusf ];
    license = licenses.mit;
  };
}
