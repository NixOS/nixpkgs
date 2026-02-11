{
  lib,
  stdenv,
  fetchurl,
  libraw1394,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdc1394";
  version = "2.2.7";

  src = fetchurl {
    url = "mirror://sourceforge/libdc1394/libdc1394-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-U3zreN087ycaGD9KF2GR0c7PhfAlUg5r03WLDhnmYJ8=";
  };

  hardeningDisable = [
    # "sorry, unimplemented: __builtin_clear_padding not supported for variable length aggregates"
    "trivialautovarinit"
  ];

  buildInputs = [ libusb1 ] ++ lib.optional stdenv.hostPlatform.isLinux libraw1394;

  meta = {
    description = "Capture and control API for IIDC compliant cameras";
    homepage = "https://sourceforge.net/projects/libdc1394/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    mainProgram = "dc1394_reset_bus";
    platforms = lib.platforms.unix;
  };
})
