{
  python3Packages,
  lib,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "easyeda2kicad";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p4G+bRB29uBohqQpI3PrkwyZId5McJ1t2Ru26hBPSks=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pydantic
    requests
  ];

  meta = {
    description = "Convert any LCSC components (including EasyEDA) to KiCad library";
    homepage = "https://github.com/uPesy/easyeda2kicad.py";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ChocolateLoverRaj ];
    mainProgram = "easyeda2kicad";
  };
}
