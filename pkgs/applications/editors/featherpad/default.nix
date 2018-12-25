{ stdenv, fetchurl, pkgconfig, qt5, fetchFromGitHub }:

with qt5;

stdenv.mkDerivation rec {
  version = "0.9.1";
  name = "featherpad-${version}";
  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "FeatherPad";
    rev = "V${version}";
    sha256 = "053j14f6fw31cdnfr8hqpxw6jh2v65z43qchdsymbrk5zji8gxla";
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
