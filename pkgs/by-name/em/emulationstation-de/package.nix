{
  lib,
  stdenv,
  fetchzip,
  cmake,
  pkg-config,
  alsa-lib,
  bluez,
  curl,
  ffmpeg,
  freeimage,
  freetype,
  gettext,
  harfbuzz,
  icu,
  libgit2,
  poppler,
  pugixml,
  SDL2,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emulationstation-de";
  version = "3.2.0";

  src = fetchzip {
    url = "https://gitlab.com/es-de/emulationstation-de/-/archive/v${finalAttrs.version}/emulationstation-de-v${finalAttrs.version}.tar.gz";
    hash = "sha256-tW8+7ImcJ3mBhoIHVE8h4cba+4SQLP55kiFYE7N8jyI=";
  };

  patches = [
    ./001-add-nixpkgs-retroarch-cores.patch
  ];

  postPatch = ''
    # ldd-based detection fails for cross builds
    substituteInPlace CMake/Packages/FindPoppler.cmake \
      --replace-fail 'GET_PREREQUISITES("''${POPPLER_LIBRARY}" POPPLER_PREREQS 1 0 "" "")' ""
  '';

  nativeBuildInputs = [
    cmake
    gettext # msgfmt
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    bluez
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
    libGL
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
