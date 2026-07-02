{
  lib,
  python3Packages,
  fetchFromGitHub,
  gettext,
}:

python3Packages.buildPythonPackage rec {
  pname = "sosreport";
  version = "4.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sosreport";
    repo = "sos";
    tag = version;
    hash = "sha256-HKGGA9SHCJjAaCPduPx1plUJ10nt3JYAr10J/69Sm/0=";
  };

  build-system = [ python3Packages.setuptools ];

  patches = [
    ./os-release.patch
  ];

  nativeBuildInputs = [
    gettext
  ];

  dependencies = with python3Packages; [
    packaging
    pexpect
    python-magic
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
    platforms = lib.platforms.linux;
  };
}
