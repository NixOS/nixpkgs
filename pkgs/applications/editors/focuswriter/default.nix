{ stdenv, fetchurl, pkgconfig, qmake, qttools, hunspell, qtbase, qtmultimedia, mkDerivation }:

mkDerivation rec {
  pname = "focuswriter";
  version = "1.7.6";

  src = fetchurl {
    url = "https://gottcode.org/focuswriter/focuswriter-${version}-src.tar.bz2";
    sha256 = "0h85f6cs9zbxv118mjfxqfv41j19zkx2xq36mpnlmrlzkjj7dx9l";
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
    homepage = "https://gottcode.org/focuswriter/";
  };
}
