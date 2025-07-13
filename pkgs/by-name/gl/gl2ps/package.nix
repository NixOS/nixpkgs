{
  lib,
  stdenv,
  fetchurl,
  cmake,
  zlib,
  libpng,
  libGL,
  libGLU,
  libglut,
}:

stdenv.mkDerivation rec {
  pname = "gl2ps";
  version = "1.4.2";

  src = fetchurl {
    url = "https://geuz.org/gl2ps/src/${pname}-${version}.tgz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      zlib
      libpng
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libGL
      libGLU
      libglut
    ];

  meta = with lib; {
    homepage = "http://geuz.org/gl2ps";
    description = "OpenGL to PostScript printing library";
    platforms = platforms.all;
    license = licenses.lgpl2;
    maintainers = with maintainers; [
      raskin
      twhitehead
    ];
  };
}
