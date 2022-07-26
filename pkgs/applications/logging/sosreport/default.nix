{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, gettext
, pexpect
}:

buildPythonPackage rec {
  pname = "sosreport";
  version = "4.3";

  src = fetchFromGitHub {
    owner = "sosreport";
    repo = "sos";
    rev = version;
    sha256 = "sha256-fLEYRRQap7xqSyUU9MAV8cxxYKydHjn8J147VTXSf78=";
  };

  patches = [
    (fetchpatch {
      # fix sos --help
      url = "https://github.com/sosreport/sos/commit/ac4eb48fa35c13b99ada41540831412480babf8d.patch";
      sha256 = "sha256-6ZRoDDZN2KkHTXOKuHTAquB/HTIUppodmx83WxxYFP0=";
    })
  ];

  nativeBuildInputs = [
    gettext
  ];

  propagatedBuildInputs = [
    pexpect
  ];

  # requires avocado-framework 94.0, latest version as of writing is 96.0
  doCheck = false;

  preCheck = ''
    export PYTHONPATH=$PWD/tests:$PYTHONPATH
  '';

  pythonImportsCheck = [ "sos" ];

  meta = with lib; {
    description = "Unified tool for collecting system logs and other debug information";
    homepage = "https://github.com/sosreport/sos";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
