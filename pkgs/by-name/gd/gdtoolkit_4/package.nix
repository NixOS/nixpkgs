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
        version = "1.2.2";
        src = fetchFromGitHub {
          owner = "lark-parser";
          repo = "lark";
          rev = version;
          hash = "sha256-Dc7wbMBY8CSeP4JE3hBk5m1lwzmCnNTkVoLdIukRw1Q=";
          fetchSubmodules = true;
        };
        patches = [ ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "gdtoolkit";
  version = "4.3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Scony";
    repo = "godot-gdscript-toolkit";
    tag = version;
    hash = "sha256-D67iwGGF3CrdAi/XKGVkusZlFCsMPIKdVpKDwcVQMrI=";
  };

  disabled = python.pythonOlder "3.7";

  propagatedBuildInputs = with python.pkgs; [
    docopt
    lark
    pyyaml
    radon
    setuptools
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

  # The tests are not working on NixOS
  disabledTestPaths = [
    "tests/generated/test_expression_parsing.py"
  ];

  pythonImportsCheck = [
    "gdtoolkit"
    "gdtoolkit.formatter"
    "gdtoolkit.gd2py"
    "gdtoolkit.gdradon"
    "gdtoolkit.linter"
    "gdtoolkit.parser"
  ];

  meta = with lib; {
    description = "Independent set of tools for working with Godot's GDScript - parser, linter and formatter";
    homepage = "https://github.com/Scony/godot-gdscript-toolkit";
    license = licenses.mit;
    maintainers = with maintainers; [ squarepear ];
  };
}
