{ stdenv, fetchurl, xorg, pkgconfig
, gtkSupport ? true, gtk
, qtSupport ? true, qt4
}:

stdenv.mkDerivation rec {
  version = "0.31";
  name = "xautoclick-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/project/xautoclick/xautoclick/xautoclick-0.31/xautoclick-0.31.tar.gz";
    sha256 = "0h522f12a7v2b89411xm51iwixmjp2mp90rnizjgiakx9ajnmqnm";
  };
  buildInputs = [ xorg.libX11 xorg.libXtst xorg.xinput xorg.libXi xorg.libXext pkgconfig ]
    ++ stdenv.lib.optionals gtkSupport [ gtk ]
    ++ stdenv.lib.optionals qtSupport [ qt4 ];
  patchPhase = ''
    substituteInPlace configure --replace /usr/X11R6 ${xorg.libX11.dev}
  '';
  preConfigure = stdenv.lib.optional qtSupport ''
    mkdir .bin
    ln -s ${qt4}/bin/moc .bin/moc-qt4
    addToSearchPath PATH .bin
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
