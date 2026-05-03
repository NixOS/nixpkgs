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
  makeWrapper,
  nlohmann_json,
  openssl,
  pkg-config,
  speexdsp,
  versionCheckHook,
  zlib,

  withDiscordRpc ? false,
  # Paths to RCT1 and RCT2 installs can be specified to have them added as a wrapped argument
  rct1Path ? null,
  rct2Path ? null,
}:

let
  objects-version = "1.7.9";
  openmusic-version = "1.6.1";
  opensfx-version = "1.0.6";
  title-sequences-version = "0.4.26";

  objects = fetchurl {
    url = "https://github.com/OpenRCT2/objects/releases/download/v${objects-version}/objects.zip";
    hash = "sha256-VUYe0gxugvFOmiec2ERlSwJkmZu5QDTVj6kS/e4m6tY=";
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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sGdtiEUmZux6FCXuxefRulfIEO8FY7wYfIBOhdSYtF8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    unzip
    makeWrapper
    versionCheckHook
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

  preConfigure =
    # Verify that the correct version of each third party repository is used.
    (
      let
        versionCheck = assetKey: url: ''
          grep -qF '"${url}"' assets.json \
            || (echo "${assetKey} differs from expected version!"; exit 1)
        '';
      in
      (versionCheck "objects" objects.url)
      + (versionCheck "openmusic" openmusic.url)
      + (versionCheck "opensfx" opensfx.url)
      + (versionCheck "title-sequences" title-sequences.url)
    );

  doInstallCheck = true;

  postInstall = ''
    wrapProgram $out/bin/openrct2 \
      ${lib.optionalString (rct1Path != null) "--add-flags '--rct1-data-path=\"${rct1Path}\"'"} \
      ${lib.optionalString (rct2Path != null) "--add-flags '--rct2-data-path=\"${rct2Path}\"'"}
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Open source re-implementation of RollerCoaster Tycoon 2";
    longDescription = ''
      OpenRCT2 is an open source re-implementation of RollerCoaster Tycoon 2, a
      construction and management simulation video game that simulates amusement
      park management.

      The original RCT2 game data is required to play.

      The path to an existing RCT1 or RCT2 installation can be provided at
      build time via the rct1Path and rct2Path arguments respectively:

        openrct2.override {
          rct1Path = "/path/to/rct1";
          rct2Path = "/path/to/rct2";
        };

      Alternatively, if no paths are provided, the game will prompt for the
      RCT2 data on first launch. For RCT1, you will then need to go to
      the game settings and specify the path to the data directory.
    '';
    homepage = "https://openrct2.io";
    changelog = "https://github.com/OpenRCT2/OpenRCT2/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/OpenRCT2/OpenRCT2/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      keenanweaver
      kylerisse
    ];
    mainProgram = "openrct2";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
