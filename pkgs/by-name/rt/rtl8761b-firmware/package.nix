{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "rtl8761b-firmware";
  version = "162105963";

  src = fetchFromGitHub {
    owner = "andrew-ld";
    repo = "rtl8761b-firmware";
    rev = "4b36bce18a5c9162d0c4f63ff70abcc5e9db9e28";
    hash = "sha256-5DB7eGmKmnn2PQUHjDmKRPiNPZjC3pkSbEiE7rjdJOI=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/lib/firmware/rtl_bt/ *

    runHook postInstall
  '';

  meta = {
    description = "Firmware for Realtek RTL8761b";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ elfenermarcell ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
  };
}
