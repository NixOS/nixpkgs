{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "sentinel";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GQko+ZUa9ulKH4Tu/K7XkcKAl90VK4jpiJBr4wBFH9I=";
  };

  meta = with lib; {
    description = "Create sentinel and singleton objects";
    homepage = "https://github.com/eddieantonio/sentinel";
    license = licenses.mit;
  };
}
