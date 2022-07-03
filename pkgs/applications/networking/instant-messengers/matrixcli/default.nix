{ lib, fetchFromGitHub
  , buildPythonApplication, buildPythonPackage
  , pygobject3, pytest-runner, requests, responses, pytest, python-olm
  , canonicaljson, olm
}:
let
  mainsrc = fetchFromGitHub {
    owner = "saadnpq";
    repo = "matrixcli";
    rev = "61ebde173ca2f77185c261c2b7f6db297ca89863";
    sha256 = "sha256-eH/8b8IyfXqUo7odSECYF+84pXTsP+5S7pFR3oWXknU=";
    fetchSubmodules = true;
  };

  sdk = buildPythonPackage rec {
    name = "${pname}-${version}";
    pname = "matrix-python-sdk-matrixcli";
    version = "0.0.2019-08-15";

    src = "${mainsrc}/matrix-python-sdk/";

    propagatedBuildInputs = [
      requests responses olm python-olm canonicaljson
      pytest-runner pytest
    ];

    doCheck = false;
    doInstallCheck = false;

    meta = {
      license = lib.licenses.asl20;
      description = "Fork of Matrix Python SDK";
      platforms = lib.platforms.linux;
    };
  };

in
buildPythonApplication rec {
  pname = "matrixcli";
  version = "0.0.2019-08-15";

  src = mainsrc;

  propagatedBuildInputs = [pygobject3 sdk];

  meta = {
    description = "CLI client for Matrix";
    license = lib.licenses.gpl3;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/saadnpq/matrixcli";
  };
}
