{ stdenv, fetchurl, gettext, libjpeg, libtiff, libungif, libpng, imlib
, xlibs, automake, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  name = "icewm-1.3.6";

  buildInputs =
    [ gettext libjpeg libtiff libungif libpng imlib
      xlibs.libX11 xlibs.libXft xlibs.libXext xlibs.libXinerama xlibs.libXrandr
      pkgconfig gtk
    ];

  src = fetchurl {
    url = "mirror://sourceforge/icewm/${name}.tar.gz";
    sha256 = "1pr7rc10rddwvy4ncng4mf5fpxd1nqjsw34xba9ngsg32rg57b91";
  };

  NIX_LDFLAGS = "-lfontconfig";

  # The fuloong2f is not supported by 1.3.6 still
  preConfigure = ''
    cp ${automake}/share/automake*/config.{sub,guess} .
  '';

  meta = {
    description = "A window manager for the X Window System";
    homepage = http://www.icewm.org/;
  };
}
