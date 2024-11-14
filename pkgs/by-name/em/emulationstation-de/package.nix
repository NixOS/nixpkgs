{
  lib,
  stdenv,
  cmake,
  fetchzip,
  pkg-config,
  alsa-lib,
  curl,
  ffmpeg,
  freeimage,
  freetype,
  libgit2,
  poppler,
  pugixml,
  SDL2
}:

stdenv.mkDerivation {
  pname = "emulationstation-de";
  version = "2.2.1";

  src = fetchzip {
    url = "https://gitlab.com/es-de/emulationstation-de/-/archive/v2.2.1/emulationstation-de-v2.2.1.tar.gz";
    hash = "sha256:1kp9p3fndnx4mapgfvy742zwisyf0y5k57xkqkis0kxyibx0z8i6";
  };

  patches = [ ./001-add-nixpkgs-retroarch-cores.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    curl
    ffmpeg
    freeimage
    freetype
    libgit2
    poppler
    pugixml
    SDL2
  ];

  installPhase = ''
    install -D ../emulationstation $out/bin/emulationstation
    cp -r ../resources/ $out/bin/resources/
  '';

  meta = {
    description = "EmulationStation Desktop Edition is a frontend for browsing and launching games from your multi-platform game collection";
    homepage = "https://es-de.org";
    maintainers = with lib.maintainers; [ ivarmedi ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "emulationstation";
  };
}
