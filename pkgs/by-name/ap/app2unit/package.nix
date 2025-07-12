{
  lib,
  stdenvNoCC,
  dash,
  scdoc,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "app2unit";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    tag = "v${version}";
    sha256 = "sha256-xHqPCA9ycPcImmyMrJZEfnfrFZ3sKfP/mhJ86CHLTQ8=";
  };

  nativeBuildInputs = [ scdoc ];

  buildPhase = ''
    scdoc < app2unit.1.scd > app2unit.1
  '';

  installPhase = ''
    install -Dt $out/bin app2unit

    for link in \
      app2unit-open \
      app2unit-open-scope \
      app2unit-open-service \
      app2unit-term \
      app2unit-term-scope \
      app2unit-term-service
    do
      ln -s $out/bin/app2unit $out/bin/$link
    done
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
