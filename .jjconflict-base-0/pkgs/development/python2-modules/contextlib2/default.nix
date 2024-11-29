{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "contextlib2";
  version = "0.6.0.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01f490098c18b19d2bd5bb5dc445b2054d2fa97f09a4280ba2c5f3c394c8162e";
  };

  # requires unittest2, which has been removed
  doCheck = false;

  meta = {
    description = "Backports and enhancements for the contextlib module";
    homepage = "https://contextlib2.readthedocs.org/";
    license = lib.licenses.psfl;
  };
}
