{ lib
, python3
, fetchFromGitHub
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      lark = super.lark.overridePythonAttrs (old: rec {
        # gdtoolkit needs exactly this lark version
        version = "1.1.9";
        src = fetchFromGitHub {
          owner = "lark-parser";
          repo = "lark";
          rev = version;
          hash = "sha256-vDu+VPAXONY8J+A6oS7EiMeOMgzGms0nWpE+DKI1MVU=";
          fetchSubmodules = true;
        };
        patches = [ ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "gdtoolkit";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "Scony";
    repo = "godot-gdscript-toolkit";
    rev = version;
    hash = "sha256-SvEKKuDnfxV+5AArg5ssrQzgIwRITdek4KYEs3d0n4Y=";
  };

  disabled = python.pythonOlder "3.7";

  propagatedBuildInputs = with python.pkgs; [
    docopt
    lark
    pyyaml
    setuptools
  ];

  doCheck = true;

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
    hypothesis
  ];

  preCheck = ''
      # The tests want to run the installed executables
      export PATH=$out/bin:$PATH

      # gdtoolkit tries to write cache variables to $HOME/.cache
      export HOME=$TMP
    '';

  # The tests are not working on NixOS
  disabledTestPaths = [
    "tests/generated/test_expression_parsing.py"
    "tests/gdradon/test_executable.py"
  ];

  pythonImportsCheck = [ "gdtoolkit" "gdtoolkit.formatter" "gdtoolkit.linter" "gdtoolkit.parser" ];

  meta = with lib; {
    description = "Independent set of tools for working with Godot's GDScript - parser, linter and formatter";
    homepage = "https://github.com/Scony/godot-gdscript-toolkit";
    license = licenses.mit;
    maintainers = with maintainers; [ squarepear ];
  };
}
