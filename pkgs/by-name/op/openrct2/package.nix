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
  libpthread-stubs,
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
  objects-version = "1.7.6";
  openmusic-version = "1.6.1";
  opensfx-version = "1.0.6";
  title-sequences-version = "0.4.26";

  objects = fetchurl {
    url = "https://github.com/OpenRCT2/objects/releases/download/v${objects-version}/objects.zip";
    hash = "sha256-asoutEH76MAi/4TVn7Ue1+pXd1ZkCXDcmJ6raF/0VpY=";
  };
  openmusic = fetchurl {
    url = "https://github.com/OpenRCT2/OpenMusic/releases/download/v${openmusic-version}/openmusic.zip";
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
  version = "0.4.32";

  src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V5DF7kaxzT2OvTgP8oUPr3y2BCFRo/RkIRqxvTdMsJY=";
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
    libpthread-stubs
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
    (lib.cmakeBool "DOWNLOAD_OPENMUSIC" false)
    (lib.cmakeBool "DOWNLOAD_OPENSFX" false)
    (lib.cmakeBool "DOWNLOAD_TITLE_SEQUENCES" false)
    (lib.cmakeBool "DISABLE_DISCORD_RPC" (!withDiscordRpc))
  ];

  postUnpack = ''
    mkdir -p $sourceRoot/data/{object,sequence}
    unzip -o ${objects} -d $sourceRoot/data/object
    unzip -o ${openmusic} -d $sourceRoot/data
    unzip -o ${opensfx} -d $sourceRoot/data
    unzip -o ${title-sequences} -d $sourceRoot/data/sequence
  '';

  # Fix blank changelog & contributors screen. See https://github.com/OpenRCT2/OpenRCT2/issues/16988
  postPatch = ''
    substituteInPlace src/openrct2/platform/Platform.Linux.cpp \
      --replace-fail "/usr/share/doc/openrct2" "$out/share/doc/openrct2"
  '';

  passthru.updateScript = ./update.sh;

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
