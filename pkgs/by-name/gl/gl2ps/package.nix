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

stdenv.mkDerivation (finalAttrs: {
  pname = "gl2ps";
  version = "1.4.2";

  src = fetchurl {
    url = "http://geuz.org/gl2ps/src/gl2ps-${finalAttrs.version}.tgz";
    sha256 = "1sgzv547h7hrskb9qd0x5yp45kmhvibjwj2mfswv95lg070h074d";
  };

  # fix build with cmake v4
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 2.8 FATAL_ERROR)' 'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
    libpng
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libGLU
    libglut
  ];

  meta = {
    homepage = "http://geuz.org/gl2ps";
    description = "OpenGL to PostScript printing library";
    platforms = lib.platforms.all;
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [
      raskin
      twhitehead
    ];
  };
})
