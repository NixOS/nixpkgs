{
  lib,
  stdenv,
  fetchurl,
  cmake,
  zlib,
  libpng,
  libGL,
}:
stdenv.mkDerivation rec {
  pname = "mathgl";
  version = "8.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/mathgl/mathgl-${version}.tar.gz";
    sha256 = "sha256-cWYJlWhKawooI/Z49sQ4q6ukdKEVJGzfX5sLRgq/ysE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
    libpng
    libGL
  ];

  meta = with lib; {
    description = "Library for scientific data visualization";
    homepage = "https://mathgl.sourceforge.net/";
    license = with licenses; [
      gpl3
      lgpl3
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.GabrielDougherty ];
  };
}
