{
  lib,
  buildPythonPackage,
  fetchPypi,
  pkgs,
  six,
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.19.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YOqtEZllmQDdCvUh7UYreTu9+GdDKzlI6HQWrkyva/g=";
  };

  propagatedBuildInputs = [ six ];
  # Only needed for tests
  nativeCheckInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = licenses.mit;
  };
}
