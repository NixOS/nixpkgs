{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage {
  pname = "mpfshell";
  version = "0.9.3-unstable-2025-01-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wendlers";
    repo = "mpfshell";
    rev = "d290096ede985e8730b2ed02d130befdb65fde4e";
    hash = "sha256-+AUlBHCzxDKatXrDmmBsf0g4cKZaa9Ui92M0d+49rKo=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    pyserial
    colorama
    websocket-client
    standard-telnetlib # Python no longer provides telnetlib since python313
  ];

  doCheck = false;
  pythonImportsCheck = [ "mp.mpfshell" ];

  meta = {
    homepage = "https://github.com/wendlers/mpfshell";
    description = "Simple shell based file explorer for ESP8266 Micropython based devices";
    mainProgram = "mpfshell";
    license = lib.licenses.mit;
  };
}
