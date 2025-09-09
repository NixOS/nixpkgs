{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libpng,
  libtiff,
  libjpeg,
  panotools,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "autopano-sift-C";
  version = "2.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/autopano-sift-C-${version}.tar.gz";
    hash = "sha256-mpApNT8kCxBanA4x5AU7N7D570vZFm3LJr4+gZxDEzc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libpng
    libtiff
    libjpeg
    panotools
    libxml2
  ];

  patches = [
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-gfx/autopano-sift-C/files/autopano-sift-C-2.5.1-lm.patch?id=dec60bb6900d6ebdaaa6aa1dcb845b30b739f9b5";
      hash = "sha256-m47Y48jI60Wl1JSJZv5nkyf3ZIkyX0noSzcCfXXJzK0=";
    })
  ];

  meta = {
    homepage = "http://hugin.sourceforge.net/";
    description = "Implementation in C of the autopano-sift algorithm for automatically stitching panoramas";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
