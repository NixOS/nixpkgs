{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.09";
  pname = "epstool";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/e/epstool/epstool_${finalAttrs.version}.orig.tar.xz";
    hash = "sha256-HoUknRpE+UGLH5Wjrr2LB4TauOSd62QXrJuZbKCPYBE=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CLINK=${stdenv.cc.targetPrefix}cc"
    "LINK=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    make EPSTOOL_ROOT=$out install
  '';

  meta = {
    description = "Utility to create or extract preview images in EPS files, fix bounding boxes and convert to bitmaps";
    homepage = "http://pages.cs.wisc.edu/~ghost/gsview/epstool.htm";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.asppsa ];
    platforms = lib.platforms.all;
    mainProgram = "epstool";
  };
})
