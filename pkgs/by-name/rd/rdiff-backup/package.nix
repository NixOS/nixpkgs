{
  lib,
  python3Packages,
  fetchPypi,
  librsync,
}:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "rdiff-backup";
  version = "2.2.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0HeDVyZrxlE7t/daRXCymySydgNIu/YHur/DpvCUWM8";
  };

  build-system = with pypkgs; [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ librsync ];

  dependencies = with pypkgs; [ pyyaml ];

  # no tests from pypi
  doCheck = false;

  pythonImportsCheck = [ "rdiff_backup" ];

  meta = with lib; {
    description = "Backup system trying to combine best a mirror and an incremental backup system";
    homepage = "https://rdiff-backup.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "rdiff-backup";
    platforms = platforms.all;
  };
}
