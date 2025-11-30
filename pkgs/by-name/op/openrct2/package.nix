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
  withDiscordRpc ? false,
}:

let
  openrct2-version = "0.4.29";

  # Those versions MUST match the pinned versions within the CMakeLists.txt
  # file. The REPLAYS repository from the CMakeLists.txt is not necessary.
  objects-version = "1.7.5";
  openmsx-version = "1.6.1";
  opensfx-version = "1.0.6";
  title-sequences-version = "0.4.26";

  objects = fetchurl {
    url = "https://github.com/OpenRCT2/objects/releases/download/v${objects-version}/objects.zip";
    hash = "sha256-yLnTA5qSD2fK8VsJ6DEsxPgNWe1/4CiGJbnM7e9gZ5c=";
  };
  openmsx = fetchurl {
    url = "https://github.com/OpenRCT2/OpenMusic/releases/download/v${openmsx-version}/openmusic.zip";
    hash = "sha256-mUs1DTsYDuHLlhn+J/frrjoaUjKEDEvUeonzP6id4aE=";
  };
  opensfx = fetchurl {
    url = "https://github.com/OpenRCT2/OpenSoundEffects/releases/download/v${opensfx-version}/opensound.zip";
    hash = "sha256-BrkPPhnCFnUt9EHVUbJqnj4bp3Vb3SECUEtzv5k2CL4=";
  };
  title-sequences = fetchurl {
    url = "https://github.com/OpenRCT2/title-sequences/releases/download/v${title-sequences-version}/title-sequences.zip";
    hash = "sha256-2ruXh7FXY0L8pN2fZLP4z6BKfmzpwruWEPR7dikFyFg=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openrct2";
  version = openrct2-version;

  src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    tag = "v${openrct2-version}";
    hash = "sha256-Udwqn8RFXaUmgbA3rXH/WZTK88HbHEQucsbDP51Oe7g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    unzip
  ];

  buildInputs = [
    SDL2
    curl
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
  ]
  ++ lib.optional withDiscordRpc discord-rpc;

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_OBJECTS" false)
    (lib.cmakeBool "DOWNLOAD_OPENMSX" false)
    (lib.cmakeBool "DOWNLOAD_OPENSFX" false)
    (lib.cmakeBool "DOWNLOAD_TITLE_SEQUENCES" false)
    (lib.cmakeBool "DISABLE_DISCORD_RPC" (!withDiscordRpc))
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
