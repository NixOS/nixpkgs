{ stdenv, fetchgit
  , buildPythonApplication, buildPythonPackage
  , pygobject3, pytestrunner, requests, responses, pytest, python-olm
  , canonicaljson, olm
}:
let
  mainsrc = fetchgit {
    url = "https://github.com/saadnpq/matrixcli";
    rev = "61ebde173ca2f77185c261c2b7f6db297ca89863";
    sha256 = "0xcjjy2xwlcixr9fwgzcfjjkivqpk104h7dslfa7lz9jq9pzqzvq";
    fetchSubmodules = true;
  };

  sdk = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "matrix-python-sdk-matrixcli";
    version = "0.0.2019-08-15";
    
    src = "${mainsrc}/matrix-python-sdk/";

    propagatedBuildInputs = [
      requests responses olm python-olm canonicaljson
      pytestrunner pytest
    ];

    doCheck = false;
    doInstallCheck = false;

    meta = {
      license = stdenv.lib.licenses.asl20;
      description = "Fork of Matrix Python SDK";
      platforms = stdenv.lib.platforms.linux;
    };
  };

in
buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "matrixcli";
  version = "0.0.2019-08-15";

  src = mainsrc;

  propagatedBuildInputs = [pygobject3 sdk];

  meta = {
    description = "CLI client for Matrix";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = "https://github.com/saadnpq/matrixcli";
  };
}
