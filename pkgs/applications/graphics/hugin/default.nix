{stdenv, fetchurl, panotools, cmake, wxGTK, libtiff, libpng, openexr, boost,
  pkgconfig, exiv2, gettext, ilmbase, enblendenfuse, autopanosiftc, mesa, freeglut,
 glew, libXmu, libXi }:

stdenv.mkDerivation rec {
  name = "hugin-2009.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/${name}.tar.gz";
    sha256 = "1xa7rnpwlv68wfkikmlrs74hqylpkh837p3narqljr2a7fxf04r9";
  };

#   patches = [ ./levmar-64-bit-alignment.patch ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  NIX_LDFLAGS = "-lrt";

  buildInputs = [ cmake panotools wxGTK libtiff libpng openexr boost pkgconfig
    exiv2 gettext ilmbase mesa freeglut glew libXmu libXi ];

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
