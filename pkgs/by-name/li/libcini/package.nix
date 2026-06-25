{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libX11,
  libXinerama,
  libXrandr,
  libGLU,
  libGL,
  glib,
  libxml2,
  pcre,
  zlib,
  SDL2,
  SDL2_ttf,
}:

stdenv.mkDerivation rec {
  pname = "libcini";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "wegank";
    repo = "libcini";
    tag = "v${version}";
    hash = "sha256-9WY77xSeH5kdeTU8MdintHVgFk8hGRW4jQ5knCCLy4o=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libX11
      libXinerama
      libXrandr
      libGLU
      libGL
    ]
    ++ [
      glib
      libxml2
      pcre
      zlib
      SDL2
      SDL2_ttf
    ];

  NIX_CFLAGS_COMPILE = [ "-I${SDL2.dev}/include/SDL2" ];

  meta = {
    description = "Simple and easy-to-use C initiation library";
    homepage = "https://github.com/wegank/libcini";
    maintainers = with lib.maintainers; [
      tarneo
    ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.gpl3Only;
  };
}
