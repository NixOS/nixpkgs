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
  version = "20250227-132106";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = version;
    hash = "sha256-WccnaIUF5M080M4vg5NzBCLpLVcE7ts/oJJE8CLRi8A=";
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
      cartr
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
