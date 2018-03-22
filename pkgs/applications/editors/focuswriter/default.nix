{ stdenv, fetchurl, pkgconfig, qmake, qttools, hunspell, qtbase, qtmultimedia }:

stdenv.mkDerivation rec {
  name = "focuswriter-${version}";
  version = "1.6.10";

  src = fetchurl {
    url = "https://gottcode.org/focuswriter/focuswriter-${version}-src.tar.bz2";
    sha256 = "0hrbycy5lapdkaa2xm90j45sgsiqdnlk9wry41kxxpdln9msabxs";
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
