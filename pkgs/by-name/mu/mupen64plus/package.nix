{
  lib,
  stdenv,
  fetchurl,
  boost,
  dash,
  freetype,
  libpng,
  libGLU,
  pkg-config,
  SDL2,
  which,
  zlib,
  nasm,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mupen64plus";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/mupen64plus/mupen64plus-core/releases/download/${finalAttrs.version}/mupen64plus-bundle-src-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-KX4XGAzXanuOqAnRob4smO1cc1LccWllqA3rWYsh4TE=";
  };

  patches = [
    # Remove unused SDL2 header that erroneously adds libX11 dependency
    ./remove-unused-header.patch
  ];

  nativeBuildInputs = [
    pkg-config
    nasm
  ];
  buildInputs = [
    boost
    dash
    freetype
    libpng
    libGLU
    SDL2
    which
    zlib
    vulkan-loader
  ];

  buildPhase = ''
    dash m64p_build.sh PREFIX="$out" COREDIR="$out/lib/" PLUGINDIR="$out/lib/mupen64plus" SHAREDIR="$out/share/mupen64plus"
  '';
  installPhase = ''
    dash m64p_install.sh DESTDIR="$out" PREFIX=""
  '';

  meta = {
    description = "Nintendo 64 Emulator";
    license = lib.licenses.gpl2Plus;
    homepage = "http://www.mupen64plus.org/";
    platforms = [ "x86_64-linux" ];
    mainProgram = "mupen64plus";
  };
})
