{
  stdenv,
  cmake,
  ninja,
  lib,
  fetchFromGitHub,
  pkg-config,
  libx11,
  libxrandr,
  libxinerama,
  libxcursor,
  libxi,
  libxext,
  libGLU,
  ffmpeg_7,
  ncurses,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "glslviewer";
  version = "3.5.2";
  src = fetchFromGitHub {
    owner = "patriciogonzalezvivo";
    repo = "glslViewer";
    fetchSubmodules = true;
    tag = finalAttrs.version;
    hash = "sha256-rfiTiyCcOa5+ZTU7JrM35mmoZNRzco6M3ZyeZ+hio4w=";
  };
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
    libGLU
    ncurses
    ffmpeg_7
    python3
  ];
  meta = {
    description = "Live GLSL coding renderer";
    homepage = "https://patriciogonzalezvivo.com/2015/glslViewer/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "glslViewer";
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
})
