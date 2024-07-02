{ lib
, stdenv
, fetchFromGitHub
, cmake
, ffmpeg
, freeglut
, freeimage
, glew
, glfw
, glm
, libGL
, libpulseaudio
, libX11
, libXau
, libXdmcp
, libXext
, libXpm
, libXrandr
, libXxf86vm
, lz4
, mpv
, pkg-config
, SDL2
, SDL2_mixer
, zlib
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "linux-wallpaperengine";
  version = "0-unstable-2023-12-24";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = "linux-wallpaperengine";
    rev = "e28780562bdf8bcb2867cca7f79b2ed398130eb9";
    hash = "sha256-VvrYOh/cvWxDx9dghZV5dcOrfMxjVCzIGhVPm9d7P2g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    freeglut
    freeimage
    glew
    glfw
    glm
    libGL
    libpulseaudio
    libX11
    libXau
    libXdmcp
    libXext
    libXrandr
    libXpm
    libXxf86vm
    mpv
    lz4
    SDL2
    SDL2_mixer.all
    zlib
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Wallpaper Engine backgrounds for Linux";
    homepage = "https://github.com/Almamu/linux-wallpaperengine";
    license = lib.licenses.gpl3Only;
    mainProgram = "linux-wallpaperengine";
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.linux;
  };
}
