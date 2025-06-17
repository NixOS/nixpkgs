{
  lib,
  stdenvNoCC,
  dash,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "app2unit";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    tag = "v${version}";
    sha256 = "fw6Vh3Jyop95TQdOFrpspbauSfqMpd0BZkZVc1k6+K0=";
  };

  installPhase = ''
    install -Dt $out/bin app2unit
    ln -s $out/bin/app2unit $out/bin/app2unit-open
    ln -s $out/bin/app2unit $out/bin/app2unit-term
  '';

  dontPatchShebangs = true;
  postFixup = ''
    substituteInPlace $out/bin/app2unit \
      --replace-fail '#!/bin/sh' '#!${lib.getExe dash}'
  '';

  meta = {
    description = "Launches Desktop Entries as Systemd user units";
    homepage = "https://github.com/Vladimir-csp/app2unit";
    license = lib.licenses.gpl3;
    mainProgram = "app2unit";
    maintainers = with lib.maintainers; [ fazzi ];
    platforms = lib.platforms.linux;
  };
}
