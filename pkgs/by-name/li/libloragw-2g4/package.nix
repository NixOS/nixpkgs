{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "libloragw-2g4";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Lora-net";
    repo = "gateway_2g4_hal";
    rev = "f14f5cf2e4caf3789bc32159fba5c10363166591";
    hash = "sha256-EvsYCkZ55nEdZXhxp7AjCw954+uUIoi2Fc3xhaIjZys=";
  };

  makeFlags = [
    "-e"
    "-C"
    "libloragw"
  ];

  preBuild = ''
    make -C libtools
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,include/libloragw-2g4}
    cp libloragw/libloragw.a $out/lib/libloragw-2g4.a
    cp libloragw/inc/* $out/include/libloragw-2g4

    runHook postInstall
  '';

  meta = {
    description = "LoRa 2.4Ghz Gateway - Linux host Hardware Abstraction Layer, and tools (Packet Forwarder...)";
    license = [
      lib.licenses.bsd3
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.stv0g ];
    platforms = [ "aarch64-linux" ];
  };
}
