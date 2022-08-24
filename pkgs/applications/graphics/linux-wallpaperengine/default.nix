{ lib
, cmake
, fetchFromGitHub
, ffmpeg
, freeglut
, glew
, glm
, glfw
, libGL
, libXpm
, libXrandr
, libXxf86vm
, lz4
, pkg-config
, SDL
, SDL_mixer
, stdenv
, zlib
, freeimage
}:

stdenv.mkDerivation rec {
  pname = "linux-wallpaperengine";
  version = "unstable-2022-10-31";

  src = fetchFromGitHub {
    owner = "Almamu";
    repo = pname;
    rev = "cb6f05ff2774a832b6fcba6678d8765995f0af3e";
    sha256 = "sha256-f9szX+eLOII5zUCdTQjWcS38WNMCysJErrexxXARJdQ=";
  };

  patches = [
    ./sdl-path.patch
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    freeimage
    ffmpeg
    freeglut
    glew
    glm
    libGL
    glfw
    libXpm
    libXrandr
    libXxf86vm
    lz4
    SDL
    SDL_mixer.all
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp linux-wallpaperengine $out/bin

    runHook postInstall
  '';


  meta = with lib; {
    description = "Wallpaper engine compatible with linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
