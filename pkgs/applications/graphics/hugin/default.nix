{stdenv, fetchurl, panotools, cmake, wxGTK, libtiff, libpng, openexr, boost
, pkgconfig, exiv2, gettext, ilmbase, enblendenfuse, autopanosiftc, mesa
, freeglut, glew, libXmu, libXi, tclap }:

stdenv.mkDerivation rec {
  name = "hugin-2011.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/${name}.tar.bz2";
    sha256 = "1bnxljgqxzfdz14l7y29wzi52x1a38mghsjavnr28fr4vfmqwjrf";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

#NIX_LDFLAGS = "-lrt";

  buildInputs = [ panotools wxGTK libtiff libpng openexr boost tclap
    exiv2 gettext ilmbase mesa freeglut glew libXmu libXi ];

  buildNativeInputs = [ cmake pkgconfig ];

  propagatedUserEnvPackages = [ enblendenfuse autopanosiftc ];

  postInstall = ''
    mkdir -p "$out/nix-support"
    echo $propagatedUserEnvPackages > $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
