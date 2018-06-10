{ stdenv, fetchurl, pkgconfig, qmake, qttools, hunspell, qtbase, qtmultimedia }:

stdenv.mkDerivation rec {
  name = "focuswriter-${version}";
  version = "1.6.13";

  src = fetchurl {
    url = "https://gottcode.org/focuswriter/focuswriter-${version}-src.tar.bz2";
    sha256 = "1qs9v5r88scahpyw8ndr622fdnaib9789jvl2jnkwi62zcivbf6n";
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
    platforms = platforms.linux;
    homepage = https://gottcode.org/focuswriter/;
  };
}
