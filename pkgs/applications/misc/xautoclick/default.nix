{ stdenv, fetchurl, xorg, pkgconfig
, gtkSupport ? true, gtk2
, qtSupport ? true, qt4
}:

stdenv.mkDerivation rec {
  version = "0.31";
  name = "xautoclick-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/project/xautoclick/xautoclick/xautoclick-0.31/xautoclick-0.31.tar.gz";
    sha256 = "0h522f12a7v2b89411xm51iwixmjp2mp90rnizjgiakx9ajnmqnm";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ xorg.libX11 xorg.libXtst xorg.xinput xorg.libXi xorg.libXext ]
    ++ stdenv.lib.optionals gtkSupport [ gtk2 ]
    ++ stdenv.lib.optionals qtSupport [ qt4 ];
  patchPhase = ''
    substituteInPlace configure --replace /usr/X11R6 ${xorg.libX11.dev}
  '';
  preConfigure = stdenv.lib.optional qtSupport ''
    mkdir .bin
    ln -s ${qt4}/bin/moc .bin/moc-qt4
    addToSearchPath PATH .bin
    sed -i -e "s@LD=\$_cc@LD=\$_cxx@" configure
  '';

  meta = with stdenv.lib; {
    description = "Autoclicker application, which enables you to automatically click the left mousebutton";
    homepage = http://xautoclick.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
