{ stdenv, fetchurl, qt4, qmake4Hook, pkgconfig, hunspell }:

stdenv.mkDerivation rec {
  name = "focuswriter-${version}";
  version = "1.5.3";

  src = fetchurl {
    url = http://gottcode.org/focuswriter/focuswriter-1.5.3-src.tar.bz2;
    sha256 = "1i58jxbiy95ijf81g8c3gwxhcg3irzssna3wv7vhrd57g4lcfj0w";
  };

  buildInputs = [ qt4 qmake4Hook pkgconfig hunspell ];
  
  qmakeFlags = [ "PREFIX=/" ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = {
    description = "Simple, distraction-free writing environment";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.all;
    homepage = http://gottcode.org/focuswriter/;
  };
}
