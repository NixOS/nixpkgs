{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "libloragw-sx1301";
  version = "5.0.1r2";

  src = fetchFromGitHub {
    owner = "brocaar";
    repo = "lora_gateway";
    rev = "59381129a07858a2a91aeffe21cd6a728219cf23";
    hash = "sha256-K+GCE3eJq/9CgjIPTCBx3dSbDP0QbTiv0QMAbbLZM7s=";
  };

  makeFlags = [
    "-e"
    "-C"
    "libloragw"
  ];

  installPhase = ''
    mkdir -p $out/{lib,include/libloragw-sx1301}
    cp libloragw/libloragw.a $out/lib/libloragw-sx1301.a
    cp libloragw/inc/* $out/include/libloragw-sx1301
  '';

  meta = {
    description = "Driver/HAL to build a gateway using a concentrator board based on Semtech SX1301 multi-channel modem and SX1257/SX1255 RF transceivers";
    license = [
      lib.licenses.bsd3
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.stv0g ];
    platforms = [ "aarch64-linux" ];
  };
}
