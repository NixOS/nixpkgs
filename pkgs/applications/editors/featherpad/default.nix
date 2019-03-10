{ stdenv, fetchurl, pkgconfig, qt5, fetchFromGitHub }:

with qt5;

stdenv.mkDerivation rec {
  version = "0.9.4";
  name = "featherpad-${version}";
  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherPad";
    rev = "V${version}";
    sha256 = "18zna6rx2qyiplr44wrkvr4avk9yy2l1s23fy3d7ql9f1fq12z3w";
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
