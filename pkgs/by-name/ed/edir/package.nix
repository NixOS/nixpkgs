{
  lib,
  fetchPypi,
  python3,
}:

let
  python3Packages = python3.pkgs;
  attrset = {
    pname = "edir";
    version = "2.28";

    src = fetchPypi {
      inherit (attrset) pname version;
      hash = "sha256-tQomMXmqOFHxxWjs1fOzh61JIs7TI6MIXK3Y6Cs/MZA=";
    };

    nativeBuildInputs = with python3Packages; [
      setuptools-scm
    ];

    propagatedBuildInputs = with python3Packages; [
      platformdirs
    ];

    pyproject = true;

    meta = {
      homepage = "https://github.com/bulletmark/edir";
      description = "Program to rename and remove files and directories using your editor";
      license = lib.licenses.gpl3Plus;
      mainProgram = "edir";
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
python3Packages.buildPythonApplication attrset
