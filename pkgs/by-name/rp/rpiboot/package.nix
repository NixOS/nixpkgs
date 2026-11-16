{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  libusb1,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpiboot";
  version = "20261103-150646";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    tag = finalAttrs.version;
    hash = "sha256-9h7oqg5QHIWJfp6oUYvJ+y6yzJp+Hd7WVFGerr2a7TM=";
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
    changelog = "https://github.com/raspberrypi/usbboot/blob/${finalAttrs.version}/debian/changelog";
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
    ];
  };
})
