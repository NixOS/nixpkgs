{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
}:

buildPythonPackage rec {
  pname = "py3dns";
  version = "4.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mGUugOzsFDxg948OazQWMcqadWDt2N3fyGTAKQJhijk=";
  };

  build-system = [ flit-core ];

  doCheck = false;

  meta = with lib; {
    description = "Python 3 DNS library";
    homepage = "https://launchpad.net/py3dns";
    license = licenses.psfl;
  };
}
