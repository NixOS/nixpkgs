{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "krakenx";
  version = "0.0.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1khw1rxra5hn7hwp16i6kgj89znq8vjsyly3r2dxx2z2bddil000";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [ python3Packages.pyusb ];

  doCheck = false; # there are no tests

  pythonImportsCheck = [ "krakenx" ];

  meta = with lib; {
    description = "Python script to control NZXT cooler Kraken X52/X62/X72";
    homepage = "https://github.com/KsenijaS/krakenx";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
