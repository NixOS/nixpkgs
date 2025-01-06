{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
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

stdenv.mkDerivation rec {
  pname = "mupen64plus";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/mupen64plus/mupen64plus-core/releases/download/${version}/mupen64plus-bundle-src-${version}.tar.gz";
    sha256 = "sha256-KX4XGAzXanuOqAnRob4smO1cc1LccWllqA3rWYsh4TE=";
  };

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

  meta = with lib; {
    description = "Nintendo 64 Emulator";
    license = licenses.gpl2Plus;
    homepage = "http://www.mupen64plus.org/";
    maintainers = [ maintainers.sander ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mupen64plus";
  };
}
