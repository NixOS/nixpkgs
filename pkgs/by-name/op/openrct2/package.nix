{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  unzip,
  nix-update-script,

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
  pname = "openrct2";
  version = "0.4.32";

  src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    tag = "v${version}";
    hash = "sha256-V5DF7kaxzT2OvTgP8oUPr3y2BCFRo/RkIRqxvTdMsJY=";
  };

  assetsMeta = builtins.fromJSON (builtins.readFile "${src}/assets.json");
  fetchAsset =
    asset:
    fetchurl {
      url = assetsMeta.${asset}.url;
      sha256 = assetsMeta.${asset}.sha256;
    };

  objects = fetchAsset "objects";
  openmusic = fetchAsset "openmusic";
  opensfx = fetchAsset "opensfx";
  title-sequences = fetchAsset "title-sequences";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

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
    (lib.cmakeBool "DOWNLOAD_OPENMSX" false)
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

  passthru.updateScript = nix-update-script { };

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
