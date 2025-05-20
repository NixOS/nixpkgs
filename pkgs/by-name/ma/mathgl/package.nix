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
  version = "8.0.3";

  src = fetchurl {
    url = "mirror://sourceforge/mathgl/mathgl-${version}.tar.gz";
    sha256 = "sha256-m7qe5qD4bRuPPzugN008t3b3ctu28aAWhMpsC9ViBNY=";
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
    # build tool make_bin is built for host
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
}
