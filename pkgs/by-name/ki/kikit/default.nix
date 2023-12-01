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
, pytestCheckHook
, commentjson
, wxPython_4_2
, pcbnew-transition
, pybars3
, versioneer
}:
let
  solidpython = callPackage ./solidpython { };

  # https://github.com/yaqwsx/KiKit/issues/574
  # copy-pasted from nixpkgs#8d8e62e74f511160a599471549a98bc9e4f4818d
  shapely = callPackage ./shapely { };
in
buildPythonApplication rec {
  pname = "kikit";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "yaqwsx";
    repo = "KiKit";
    rev = "v${version}";
    hash = "sha256-kDTPk/R3eZtm4DjoUV4tSQzjGQ9k8MKQedX4oUXYzeo=";
  };

  propagatedBuildInputs = [
    kicad
    numpy
    click
    markdown2
    commentjson
    # https://github.com/yaqwsx/KiKit/issues/575
    wxPython_4_2
    pcbnew-transition
    pybars3
    shapely
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
