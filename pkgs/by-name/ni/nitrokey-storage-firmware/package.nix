{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
}:
let
  pname = "nitrokey-storage-firmware";
  version = "0.57";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-storage-firmware";
    rev = "V${version}";
    hash = "sha256-u8IK57NVS/IOPIE3Ah/O8WuOIr0EY6AF1bEaeDgIBuk=";
  };

  toolchain = stdenv.mkDerivation (finalAttrs: {
    pname = "avr32-toolchain";
    version = "3.0.0.201009140852";

    src = fetchzip {
      url = "https://ww1.microchip.com/downloads/archive/avr32studio-ide-2.6.0.753-linux.gtk.x86_64.zip";
      hash = "sha256-MwsaGyNqbO0lBy1rcczuvKOaGbO3f0V+j84sUCkRlxc=";
    };

    postPatch = ''
      cp ${src}/pm_240.h plugins/com.atmel.avr.toolchains.linux.x86_64_${finalAttrs.version}/os/linux/x86_64/avr32/include/avr32/pm_231.h
    '';

    installPhase = ''
      runHook preInstall
      cp -r plugins/com.atmel.avr.toolchains.linux.x86_64_${finalAttrs.version}/os/linux/x86_64 $out
      rm -r $out/avr $out/bin/avr-*
      runHook postInstall
    '';

    meta = {
      description = "AVR32 toolchain";
      homepage = "https://web.archive.org/web/20210419192039/https://www.microchip.com/mplab/avr-support/avr-and-sam-downloads-archive";
      # The zip does not explicitly say this,
      # it only mentions the license(s) of AVR32 Studio.
      # Because it is very clearly a fork of GCC 4.3.3,
      # it should be licensed under GPLv2+
      license = lib.licenses.gpl2Plus;
      platforms = [ "x86_64-linux" ];
    };
  });
in
stdenv.mkDerivation {
  inherit pname version src;

  sourceRoot = "${src.name}/src";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(shell git describe)' "V${version}"
  '';

  makeFlags = [
    "CC=${toolchain}/bin/avr32-gcc"
    "nitrokey-storage-V${version}-reproducible.hex"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -D nitrokey-storage-V${version}-reproducible.hex $out/nitrokey-storage-V${version}-reproducible.hex
    runHook postInstall
  '';

  meta = {
    description = "Firmware for the Nitrokey Storage device";
    homepage = "https://github.com/Nitrokey/nitrokey-storage-firmware";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      imadnyc
      kiike
      amerino
    ];
    platforms = [ "x86_64-linux" ];
  };
}
