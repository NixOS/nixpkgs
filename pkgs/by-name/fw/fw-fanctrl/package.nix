{
  lib,
  python3Packages,
  python3,
  fw-ectool,
  fetchFromGitHub,
}:

python3Packages.buildPythonPackage rec {
  pname = "fw-fanctrl";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TamtamHero";
    repo = "fw-fanctrl";
    tag = "v${version}";
    hash = "sha256-ZWUopNfIxSr5y3M+PwGPM17R4Y2ygRNlmt/81+4ZoHs=";
  };

  nativeBuildInputs = [ python3 ];

  propagatedBuildInputs = with python3Packages; [
    fw-ectool
    setuptools
    jsonschema
  ];

  postInstall = ''
    mkdir -p $out/share/fw-fanctrl
    cp $src/src/fw_fanctrl/_resources/config.json $out/share/fw-fanctrl/config.json
    cp $src/services/system-sleep/fw-fanctrl-suspend $out/share/fw-fanctrl/fw-fanctrl-suspend
    substituteInPlace $out/share/fw-fanctrl/fw-fanctrl-suspend \
      --replace-fail '#!/bin/sh' '#!/usr/bin/env sh' \
      --replace-fail '/usr/bin/python3 "%PYTHON_SCRIPT_INSTALLATION_PATH%"' $out/bin/fw-fanctrl
  '';

  doCheck = false;

  meta = with lib; {
    mainProgram = "fw-fanctrl";
    homepage = "https://github.com/TamtamHero/fw-fanctrl";
    description = "Simple systemd service to better control Framework Laptop's fan(s)";
    platforms = lib.platforms.linux;
    license = licenses.bsd3;
    maintainers = [ lib.maintainers.Svenum ];
  };
}
