{
  lib,
  python3,
  fetchFromGitLab,
  fetchFromGitHub,
}:
let
  python = python3.override {
    packageOverrides = self: super: {
      lark010 = super.lark.overridePythonAttrs (old: rec {
        version = "0.10.0";

        src = fetchFromGitHub {
          owner = "lark-parser";
          repo = "lark";
          tag = version;
          sha256 = "sha256-ctdPPKPSD4weidyhyj7RCV89baIhmuxucF3/Ojx1Efo=";
        };

        patches = [ ];

        disabledTestPaths = [ "tests/test_nearley/test_nearley.py" ];
      });
    };
    self = python;
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "sca2d";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "bath_open_instrumentation_group";
    repo = "sca2d";
    tag = "v${version}";
    hash = "sha256-p0Bv8jcnjcOLBAXN5A4GspSIEG4G4NPA4o0aEtwe/LU=";
  };

  build-system = with python.pkgs; [ setuptools ];

  dependencies = with python.pkgs; [
    lark010
    colorama
  ];

  pythonImportsCheck = [ "sca2d" ];

  meta = {
    description = "Experimental static code analyser for OpenSCAD";
    mainProgram = "sca2d";
    homepage = "https://gitlab.com/bath_open_instrumentation_group/sca2d";
    changelog = "https://gitlab.com/bath_open_instrumentation_group/sca2d/-/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ traxys ];
  };
}
