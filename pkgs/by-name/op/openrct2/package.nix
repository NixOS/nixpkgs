{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  unzip,

  SDL2,
  cmake,
  curl,
  discord-rpc,
  duktape,
  expat,
  flac,
  fontconfig,
  freetype,
  gbenchmark,
  icu,
  innoextract,
  jansson,
  libGLU,
  libiconv,
  libogg,
  libpng,
  libpthreadstubs,
  libvorbis,
  libzip,
  nlohmann_json,
  openssl,
  pkg-config,
  speexdsp,
  zlib,
}:

let
  openrct2-version = "0.4.23";

  # Those versions MUST match the pinned versions within the CMakeLists.txt
  # file. The REPLAYS repository from the CMakeLists.txt is not necessary.
  objects-version = "1.6.1";
  openmsx-version = "1.6";
  opensfx-version = "1.0.5";
  title-sequences-version = "0.4.14";

  objects = fetchurl {
    url = "https://github.com/OpenRCT2/objects/releases/download/v${objects-version}/objects.zip";
    hash = "sha256-aCkYZjDlLDMrakhH67k2xUmlIvytr49eXkV5xMkaRFA=";
  };
  openmsx = fetchurl {
    url = "https://github.com/OpenRCT2/OpenMusic/releases/download/v${openmsx-version}/openmusic.zip";
    hash = "sha256-8JfTpMzTn3VG+X2z7LG4vnNkj1O3p1lbhszL3Bp1V+Q=";
  };
  opensfx = fetchurl {
    url = "https://github.com/OpenRCT2/OpenSoundEffects/releases/download/v${opensfx-version}/opensound.zip";
    hash = "sha256-qVIUi+FkwSjk/TrqloIuXwUe3ZoLHyyE3n92KM47Lhg=";
  };
  title-sequences = fetchurl {
    url = "https://github.com/OpenRCT2/title-sequences/releases/download/v${title-sequences-version}/title-sequences.zip";
    hash = "sha256-FA33FOgG/tQRzEl2Pn8WsPzypIelcAHR5Q/Oj5FIqfM=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openrct2";
  version = openrct2-version;

  src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${openrct2-version}";
    hash = "sha256-vCnMVfRTF79oWsYorsI5/Mj7/P32G5uZMskW2SUSYlg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    unzip
  ];

  buildInputs = [
    SDL2
    curl
    discord-rpc
    duktape
    expat
    flac
    fontconfig
    freetype
    gbenchmark
    icu
    innoextract
    jansson
    libGLU
    libiconv
    libogg
    libpng
    libpthreadstubs
    libvorbis
    libzip
    nlohmann_json
    openssl
    speexdsp
    zlib
  ];

  cmakeFlags = [
    "-DDOWNLOAD_OBJECTS=OFF"
    "-DDOWNLOAD_OPENMSX=OFF"
    "-DDOWNLOAD_OPENSFX=OFF"
    "-DDOWNLOAD_TITLE_SEQUENCES=OFF"
  ];

  postUnpack = ''
    mkdir -p $sourceRoot/data/{object,sequence}
    unzip -o ${objects} -d $sourceRoot/data/object
    unzip -o ${openmsx} -d $sourceRoot/data
    unzip -o ${opensfx} -d $sourceRoot/data
    unzip -o ${title-sequences} -d $sourceRoot/data/sequence
  '';

  # Fix blank changelog & contributors screen. See https://github.com/OpenRCT2/OpenRCT2/issues/16988
  postPatch = ''
    substituteInPlace src/openrct2/platform/Platform.Linux.cpp \
      --replace-fail "/usr/share/doc/openrct2" "$out/share/doc/openrct2"
  '';

  preConfigure =
    # Verify that the correct version of each third party repository is used.
    (
      let
        versionCheck = cmakeKey: version: ''
          grep -q '^set(${cmakeKey}_VERSION "${version}")$' CMakeLists.txt \
            || (echo "${cmakeKey} differs from expected version!"; exit 1)
        '';
      in
      (versionCheck "OBJECTS" objects-version)
      + (versionCheck "OPENMSX" openmsx-version)
      + (versionCheck "OPENSFX" opensfx-version)
      + (versionCheck "TITLE_SEQUENCE" title-sequences-version)
    );

  meta = {
    description = "Open source re-implementation of RollerCoaster Tycoon 2 (original game required)";
    homepage = "https://openrct2.io/";
    downloadPage = "https://github.com/OpenRCT2/OpenRCT2/releases";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      oxzi
      keenanweaver
      kylerisse
    ];
  };
})
