{ stdenv, fetchurl, pkgconfig, qmake, qttools, hunspell, qtbase, qtmultimedia }:

stdenv.mkDerivation rec {
  name = "focuswriter-${version}";
  version = "1.6.7";

  src = fetchurl {
    url = "https://gottcode.org/focuswriter/focuswriter-${version}-src.tar.bz2";
    sha256 = "10rqzinr6yd6ca06rklg34kdc08a3xgygfzmprsfg7gdsybfay5z";
  };

  nativeBuildInputs = [ pkgconfig qmake qttools ];
  buildInputs = [ hunspell qtbase qtmultimedia ];

  enableParallelBuilding = true;

  qmakeFlags = [ "PREFIX=/" ];
  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with stdenv.lib; {
    description = "Simple, distraction-free writing environment";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ madjar ];
    platforms = platforms.all;
    homepage = https://gottcode.org/focuswriter/;
  };
}
