{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rjsmin";
  version = "1.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/8vgTg36w5zqj7vLQcOLLgcjXOIYi8oV6ZjaHTSKeGA=";
  };

  # The package does not ship tests, and the setup machinery confuses
  # tests auto-discovery
  doCheck = false;

  pythonImportsCheck = [ "rjsmin" ];

  meta = with lib; {
    description = "Module to minify Javascript";
    homepage = "http://opensource.perlig.de/rjsmin/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
