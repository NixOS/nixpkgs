{ stdenv, fetchurl, gettext, libjpeg, libtiff, libungif, libpng, freetype
, fontconfig, xlibs, automake, pkgconfig, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "icewm-1.3.8";

  buildInputs =
    [ gettext libjpeg libtiff libungif libpng
      xlibs.libX11 xlibs.libXft xlibs.libXext xlibs.libXinerama xlibs.libXrandr
      xlibs.libICE xlibs.libSM freetype fontconfig
      pkgconfig gdk_pixbuf
    ];

  src = fetchurl {
    url = "mirror://sourceforge/icewm/${name}.tar.gz";
    sha256 = "066d1mw0vm9ygxnyxksfi6k4vzclvnlkvj04pj3kbcmv1fg8sn0p";
  };

  NIX_LDFLAGS = "-lfontconfig";

  # The fuloong2f is not supported by 1.3.6 still
  #
  # Don't know whether 1.3.7 supports fuloong2f and don't know how to test it
  # on x86_64 hardware. So I left this 'cp' -- urkud

  preConfigure = ''
    cp -v ${automake}/share/automake*/config.{sub,guess} .
  '';

  meta = {
    description = "A window manager for the X Window System";
    homepage = http://www.icewm.org/;
    platforms = stdenv.lib.platforms.unix;
  };
}
