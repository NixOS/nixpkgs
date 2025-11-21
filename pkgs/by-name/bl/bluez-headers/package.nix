{
  lib,
  stdenv,
  fetchurl,
}:

# This package only provides the bluetooth headers from the bluez package
# for consumption in Python, which cannot consume bluez.dev due to multiple
# infinite recursion paths.

stdenv.mkDerivation (finalAttrs: {
  pname = "bluez-headers";
  version = "5.84";

  # This package has the source, because of the emulatorAvailable check in the
  # bluez function args, that causes an infinite recursion with Python on cross
  # builds.
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/bluez-${finalAttrs.version}.tar.xz";
    hash = "sha256-W6c9Aw97AAh9Z4ALDjIWAa7A+JKCfHLlosg5DYyIaxE=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/include/
    cp -rv lib/* "$out/include/"
  '';

  meta = {
    homepage = "https://www.bluez.org/";
    description = "Official Linux Bluetooth protocol stack";
    changelog = "https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/ChangeLog?h=${finalAttrs.version}";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
      lgpl21Plus
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
