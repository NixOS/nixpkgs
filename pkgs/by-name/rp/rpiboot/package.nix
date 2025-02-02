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
  version = "20240926-102326";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = version;
    hash = "sha256-9m7PAw1WNQlfqOr5hDXrCsZlZLBmvoGUT58NN2cVolw=";
  };

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];

  patchPhase = ''
    sed -i "s@/usr/@$out/@g" main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/rpiboot
    cp rpiboot $out/bin
    cp -r msd firmware eeprom-erase mass-storage-gadget* recovery* secure-boot* rpi-imager-embedded $out/share/rpiboot
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
