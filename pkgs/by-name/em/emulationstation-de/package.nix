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
  version = "3.1.0";

  src = fetchzip {
    url = "https://gitlab.com/es-de/emulationstation-de/-/archive/v${finalAttrs.version}/emulationstation-de-v${finalAttrs.version}.tar.gz";
    hash = "sha256-v9nOY9T5VOVLBUKoDXqwYa1iYvW42iGA+3kpPUOmHkg=";
  };

  patches = [
    (fetchpatch {
      name = "fix-buffer-overflow-detection-with-gcc-fortification";
      url = "https://gitlab.com/es-de/emulationstation-de/-/commit/41fd33fdc3dacef507b987ed316aec2b0d684317.patch";
      sha256 = "sha256-LHJ11mtBn8hRU97+Lz9ugPTTGUAxrPz7yvyxqNOAYKY=";
    })
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
