{
  lib,
  python3Packages,
  fetchPypi,
  git,
  mercurial,
}:

with python3Packages;

buildPythonApplication rec {
  pname = "mbed-cli";
  version = "1.10.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-X+hNVM8fsy0VFTqFr1pPKWRimacBenTcY4y+PBJpvlI=";
  };

  nativeCheckInputs = [
    git
    mercurial
    pytest
  ];

  checkPhase = ''
    export GIT_COMMITTER_NAME=nixbld
    export EMAIL=nixbld@localhost
    export GIT_COMMITTER_DATE=$SOURCE_DATE_EPOCH
    pytest test
  '';

  meta = with lib; {
    homepage = "https://github.com/ARMmbed/mbed-cli";
    description = "Arm Mbed Command Line Interface";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
