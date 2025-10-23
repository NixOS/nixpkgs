{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  libusb1,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "rpiboot";
  version = "20250908-162618-bookworm";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    tag = version;
    hash = "sha256-BJOm8VBEbrUasYwuV8NqwmsolJzmaqIaxYqj9EkU5hc=";
    fetchSubmodules = true;
  };

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];

  makeFlags = [ "INSTALL_PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/raspberrypi/usbboot";
    changelog = "https://github.com/raspberrypi/usbboot/blob/${version}/debian/changelog";
    description = "Utility to boot a Raspberry Pi CM/CM3/CM4/Zero over USB";
    mainProgram = "rpiboot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      flokli
      stv0g
    ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "armv7l-linux"
      "armv6l-linux"
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
}
