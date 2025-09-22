{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  sdcc,
}:

stdenv.mkDerivation {
  pname = "sigrok-firmware-fx2lafw";
  version = "0.1.7-unstable-2024-02-03";

  src = fetchgit {
    url = "git://sigrok.org/sigrok-firmware-fx2lafw";
    rev = "0f2d3242ffb5582e5b9a018ed9ae9812d517a56e";
    hash = "sha256-xveVcwAwtqKGD3/UvnBz5ASvTyg/6jAlTedZElhV2HE=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    sdcc
  ];

  meta = with lib; {
    description = "Firmware for FX2 logic analyzers";
    homepage = "https://sigrok.org/";

    # licensing details explained in:
    # https://sigrok.org/gitweb/?p=sigrok-firmware-fx2lafw.git;a=blob;f=README;hb=HEAD#l122
    license = with licenses; [
      gpl2Plus # overall
      lgpl21Plus # fx2lib, Hantek 6022BE, Sainsmart DDS120 firmwares
    ];

    sourceProvenance = with sourceTypes; [ fromSource ];
    platforms = platforms.all;
    maintainers = with maintainers; [
      panicgh
      vifino
    ];
  };
}
