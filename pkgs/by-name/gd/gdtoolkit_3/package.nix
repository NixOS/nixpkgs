{
  lib,
  python3,
  fetchFromGitHub,
  addBinToPathHook,
  writableTmpDirAsHomeHook,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      lark = super.lark.overridePythonAttrs (old: rec {
        # gdtoolkit needs exactly this lark version
        version = "0.8.0";
        src = fetchFromGitHub {
          owner = "lark-parser";
          repo = "lark";
          tag = version;
          hash = "sha256-KN9buVlH8hJ8t0ZP5yefeYM5vH5Gg7a7TEDGKJYpozs=";
          fetchSubmodules = true;
        };
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "gdtoolkit3";
  version = "3.6.0";
  pyproject = true;

  # If we try to get using fetchPypi it requires GeoIP (but the package dont has that dep!?)
  src = fetchFromGitHub {
    owner = "Scony";
    repo = "godot-gdscript-toolkit";
    tag = version;
    hash = "sha256-DRZgjCrz/U6jPx1grNuhZTx9iXNyxzR6xWoAm5DKtoA=";
  };

  # pkg_resources is deprecated and causes tests to fail
  patches = [
    ./0001-Get-version-with-importlib-instead-of-pkg_resource.patch
  ];

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    docopt
    lark
    pyyaml
    radon
  ];

  doCheck = true;

  nativeCheckInputs =
    with python.pkgs;
    [
      pytestCheckHook
      hypothesis
    ]
    ++ [
      addBinToPathHook
      writableTmpDirAsHomeHook
    ];

  pythonImportsCheck = [
    "gdtoolkit"
    "gdtoolkit.formatter"
    "gdtoolkit.linter"
    "gdtoolkit.parser"
  ];

  meta = {
    description = "Independent set of tools for working with Godot's GDScript - parser, linter and formatter";
    homepage = "https://github.com/Scony/godot-gdscript-toolkit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      shiryel
      tmarkus
    ];
  };
}
