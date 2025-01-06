{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "edir";
  version = "2.30";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kqFJhPIdinqPBKfNY3lHeMXpzrcnSkFODGBiqGt/whM=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
    platformdirs
  ];

  meta = {
    description = "Program to rename and remove files and directories using your editor";
    homepage = "https://github.com/bulletmark/edir";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ guyonvarch ];
    platforms = lib.platforms.all;
    mainProgram = "edir";
  };
}
