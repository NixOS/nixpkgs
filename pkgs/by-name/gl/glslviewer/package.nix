{
  stdenv,
  cmake,
  ninja,
  lib,
  fetchFromGitHub,
  pkg-config,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libXext,
  libGLU,
  ffmpeg_7,
  ncurses,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "glslviewer";
  version = "3.5.1";
  src = fetchFromGitHub {
    owner = "patriciogonzalezvivo";
    repo = "glslViewer";
    fetchSubmodules = true;
    tag = finalAttrs.version;
    hash = "sha256-gQF3hkudQXxI3t1e0Iaa4dYbVc3I7lBekt5jmJLJFpI=";
  };
  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    libX11
    libXrandr
    libXinerama
    libXcursor
    libXi
    libXext
    libGLU
    ncurses
    ffmpeg_7
    python3
  ];
  meta = {
    description = "Live GLSL coding renderer";
    homepage = "https://patriciogonzalezvivo.com/2015/glslViewer/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.hodapp ];
    platforms = lib.platforms.unix;
    mainProgram = "glslViewer";
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
})
