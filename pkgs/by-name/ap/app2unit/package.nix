{
  lib,
  stdenvNoCC,
  dash,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "app2unit";
  version = "0-unstable-2025-05-09";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    rev = "7b9672a2dc16bdfbe7b7b7c27043529ca3bcb6ae";
    sha256 = "03dnx5v75530fwppfgpjl6xzzmdbk73ymrlix129d9n5sqrz9wgk";
  };

  installPhase = ''
    install -Dt $out/bin app2unit
    ln -s $out/bin/app2unit $out/bin/app2unit-open
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
