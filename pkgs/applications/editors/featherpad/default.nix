{ stdenv, fetchurl, pkgconfig, qt5, fetchFromGitHub }:

with qt5;

stdenv.mkDerivation rec {
  version = "0.9.2";
  name = "featherpad-${version}";
  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherPad";
    rev = "V${version}";
    sha256 = "1kpv8x3m4hiz7q9k7qadgbrys5nyzm7v5mhjyk22hawnp98m9x4q";
  };
  nativeBuildInputs = [ qmake pkgconfig qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras ];
  meta = with stdenv.lib; {
    description = "Lightweight Qt5 Plain-Text Editor for Linux";
    homepage = https://github.com/tsujan/FeatherPad;
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
    license = licenses.gpl3;
  };
}
