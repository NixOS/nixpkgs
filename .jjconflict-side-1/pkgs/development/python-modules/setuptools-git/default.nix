{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkgs,
}:

buildPythonPackage rec {
  pname = "setuptools-git";
  version = "1.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff64136da01aabba76ae88b050e7197918d8b2139ccbf6144e14d472b9c40445";
  };

  propagatedBuildInputs = [ pkgs.git ];
  doCheck = false;

  meta = with lib; {
    description = "Setuptools revision control system plugin for Git";
    homepage = "https://pypi.python.org/pypi/setuptools-git";
    license = licenses.bsd3;
  };
}
