{stdenv, fetchurl, panotools, cmake, wxGTK, libtiff, libpng, openexr, boost,
  pkgconfig, exiv2, gettext, ilmbase, enblendenfuse, autopanosiftc }:

stdenv.mkDerivation {
  name = "hugin-0.7.0";

  src = fetchurl {
    url = mirror://sourceforge/hugin/hugin-0.7.0.tar.gz;
    sha256 = "0nbrvzz94gqgk2v1900lly101g0wjz4zksnh5718226n2g8zlccf";
  };

  patches = [ ./levmar-64-bit-alignment.patch ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  NIX_LDFLAGS = "-lrt";

  buildInputs = [ cmake panotools wxGTK libtiff libpng openexr boost pkgconfig
    exiv2 gettext ilmbase ];

  postInstall = ''
    ensureDir "$out/nix-support"
    echo "${enblendenfuse} ${autopanosiftc}" > $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
