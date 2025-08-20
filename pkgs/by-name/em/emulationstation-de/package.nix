{
  lib,
  stdenv,
  fetchzip,
  fetchpatch,
  cmake,
  pkg-config,
  alsa-lib,
  curl,
  ffmpeg,
  freeimage,
  freetype,
  harfbuzz,
  icu,
  libgit2,
  poppler,
  pugixml,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emulationstation-de";
  version = "3.1.1";

  src = fetchzip {
    url = "https://gitlab.com/es-de/emulationstation-de/-/archive/v${finalAttrs.version}/emulationstation-de-v${finalAttrs.version}.tar.gz";
    hash = "sha256-pQHT/BEtIWc8tQXPjU5KFt8jED+4IqcZR+VMmAFc940=";
  };

  patches = [
    ./001-add-nixpkgs-retroarch-cores.patch
  ];

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
    harfbuzz
    icu
    libgit2
    poppler
    pugixml
    SDL2
  ];

  cmakeFlags = [ (lib.cmakeBool "APPLICATION_UPDATER" false) ];

  meta = {
    description = "ES-DE (EmulationStation Desktop Edition) is a frontend for browsing and launching games from your multi-platform collection";
    homepage = "https://es-de.org";
    maintainers = with lib.maintainers; [ ivarmedi ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "es-de";
  };
})
