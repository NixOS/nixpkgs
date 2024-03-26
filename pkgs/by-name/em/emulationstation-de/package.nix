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

stdenv.mkDerivation (finalAttrs: {
  pname = "emulationstation-de";
  version = "3.0.1";

  src = fetchzip {
    url = "https://gitlab.com/es-de/emulationstation-de/-/archive/v${finalAttrs.version}/emulationstation-de-v${finalAttrs.version}.tar.gz";
    hash = "sha256:8hkHD0vdGo6iYr76S4It97YJyvY27vCkT9DBL+cKUTE=";
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
    runHook preInstall

    install -Dm755 ../es-de $out/bin/es-de
    mkdir -p $out/share/es-de/
    cp -r ../resources/ $out/share/es-de/resources/

    runHook postInstall
  '';

  meta = {
    description = "EmulationStation Desktop Edition is a frontend for browsing and launching games from your multi-platform game collection.";
    homepage = "https://es-de.org";
    maintainers = with lib.maintainers; [ ivarmedi ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "es-de";
  };
})
