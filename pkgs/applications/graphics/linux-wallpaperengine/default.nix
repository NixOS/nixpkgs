{ lib
, stdenv
, fetchFromGitHub
, cmake
, freeimage
, libXrandr
, libXi
, libXinerama
, libXcursor
, libGL
, glew
, freeglut
, lz4
, ffmpeg
, libXxf86vm
, glm
, glfw
, mpv
, libpulseaudio
, zlib
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "linux-wallpaperengine";
  version = "unstable-2023-09-23";
  
  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    rev = "21c38d9fd1d3d89376c870cec5c5e5dc7086bc3c";
    hash = "sha256-bZlMHlNKSydh9eGm5cFSEtv/RV9sA5ABs99uurblBZY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libXrandr
    freeimage
    libXi
    libGL
    glew
    freeglut
    libXinerama
    libXcursor
    lz4
    ffmpeg
    libXxf86vm
    glm
    glfw
    mpv
    libpulseaudio
    zlib
    SDL2
  ];

  meta = {
    description = "Wallpaper Engine backgrounds for Linux!";
    license = "lib.licenses.gpl3Only";
    platforms = lib.platforms.linux;
  };
}
