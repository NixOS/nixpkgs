{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  # NOTE: this should be updated with linux_rpi
  pname = "raspberrypi-firmware";
  version = "1.20260408";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    hash = "sha256-4+eqk+3WxSZRfaGyRIW3zGC6ABo50PKGke0en2IvgXk=";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/
    mv boot "$out/share/raspberrypi/"
  '';

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  meta = {
    description = "Firmware for the Raspberry Pi board";
    homepage = "https://github.com/raspberrypi/firmware";
    license = lib.licenses.unfreeRedistributableFirmware; # See https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom
    maintainers = [ ];
    # Hash mismatch on source, mystery.
    # Maybe due to https://github.com/NixOS/nix/issues/847
    broken = stdenvNoCC.hostPlatform.isDarwin;
  };
}
