{ lib
, python3
, fetchFromGitHub
}:

let
  python = python3.override {
    packageOverrides = self: super: {
      lark = super.lark.overridePythonAttrs (old: rec {
        # gdtoolkit needs exactly this lark version
        version = "0.8.0";
        src = fetchFromGitHub {
          owner = "lark-parser";
          repo = "lark";
          rev = version;
          hash = "sha256-KN9buVlH8hJ8t0ZP5yefeYM5vH5Gg7a7TEDGKJYpozs=";
          fetchSubmodules = true;
        };
        patches = [ ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "gdtoolkit3";
  version = "3.5.0";

  # If we try to get using fetchPypi it requires GeoIP (but the package dont has that dep!?)
  src = fetchFromGitHub {
    owner = "Scony";
    repo = "godot-gdscript-toolkit";
    rev = version;
    hash = "sha256-cMGD5Xdf9ElS1NT7Q0NPB//EvUO0MI0VTtps5JRisZ4=";
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
  disabledTests = [ "test_cc_on_empty_file_succeeds" "test_cc_on_file_with_single_function_succeeds" ];

  pythonImportsCheck = [ "gdtoolkit" "gdtoolkit.formatter" "gdtoolkit.linter" "gdtoolkit.parser" ];

  meta = with lib; {
    description = "Independent set of tools for working with Godot's GDScript - parser, linter and formatter";
    homepage = "https://github.com/Scony/godot-gdscript-toolkit";
    license = licenses.mit;
    maintainers = with maintainers; [ shiryel tmarkus ];
  };
}
