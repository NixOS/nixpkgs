{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
}:

python3Packages.buildPythonPackage rec {
  pname = "sosreport";
  version = "4.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sosreport";
    repo = "sos";
    tag = version;
    hash = "sha256-97S8b4PfjUN8uzvp01PGCLs4J3CbwpJsgBKtY8kI0HE=";
  };

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    gettext
  ];

  dependencies = with python3Packages; [
    packaging
    pexpect
    pyyaml
  ];

  # requires avocado-framework 94.0, latest version as of writing is 96.0
  doCheck = false;

  preCheck = ''
    export PYTHONPATH=$PWD/tests:$PYTHONPATH
  '';

  pythonImportsCheck = [ "sos" ];

  meta = {
    description = "Unified tool for collecting system logs and other debug information";
    homepage = "https://github.com/sosreport/sos";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}
