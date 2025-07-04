{
  python3Packages,
  lib,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "easyeda2kicad";
  version = "0.8.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p4G+bRB29uBohqQpI3PrkwyZId5McJ1t2Ru26hBPSks=";
  };

  dependencies = with python3Packages; [
    setuptools
    pydantic
    requests
  ];

  meta = with lib; {
    description = "Convert any LCSC components (including EasyEDA) to KiCad library";
    homepage = "https://github.com/uPesy/easyeda2kicad.py";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ChocolateLoverRaj ];
    mainProgram = "easyeda2kicad";
  };
}
