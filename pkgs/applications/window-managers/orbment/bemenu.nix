{ stdenv, fetchFromGitHub, cmake, pkgconfig
, pango, wayland, libxkbcommon }:

stdenv.mkDerivation rec {
  name = "bemenu-2017-02-14";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = "bemenu";
    rev = "d6261274cf0b3aa51ce8ea7418a79495b20ad558";
    sha256 = "08bc623y5yjbz7q83lhl6rb0xs6ji17z79c260bx0fgin8sfj5x8";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ pango wayland libxkbcommon ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A dynamic menu library and client program inspired by dmenu";
    homepage = src.meta.homepage;
    license = with licenses; [ gpl3 lgpl3 ];
    platforms = platforms.linux;
  };
}
