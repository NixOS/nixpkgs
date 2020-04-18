{ stdenv, pkgconfig, qt5, fetchFromGitHub }:

with qt5;

stdenv.mkDerivation rec {
  version = "0.10.0";
  pname = "featherpad";
  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherPad";
    rev = "V${version}";
    sha256 = "1wrbs6kni9s3x39cckm9kzpglryxn5vyarilvh9pafbzpc6rc57p";
  };
  nativeBuildInputs = [ qmake pkgconfig qttools ];
  buildInputs = [ qtbase qtsvg qtx11extras ];
  meta = with stdenv.lib; {
    description = "Lightweight Qt5 Plain-Text Editor for Linux";
    homepage = "https://github.com/tsujan/FeatherPad";
    platforms = platforms.linux;
    maintainers = [ maintainers.flosse ];
    license = licenses.gpl3;
  };
}
