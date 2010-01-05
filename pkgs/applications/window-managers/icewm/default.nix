{ stdenv, fetchurl, gettext, libjpeg, libtiff, libungif, libpng, imlib, xlibs }:

stdenv.mkDerivation rec {
  name = "icewm-1.2.37";

  buildInputs =
    [ gettext libjpeg libtiff libungif libpng imlib
      xlibs.libX11 xlibs.libXft xlibs.libXext xlibs.libXinerama xlibs.libXrandr
    ];

  src = fetchurl {
    url = "mirror://sourceforge/icewm/${name}.tar.gz";
    sha256 = "15852k96z2w19v3d02jynxyf6ld378hbkd6lpy64byysrmjh3dmz";
  };

  meta = {
    description = "A window manager for the X Window System";
    homepage = http://www.icewm.org/;
  };
}
