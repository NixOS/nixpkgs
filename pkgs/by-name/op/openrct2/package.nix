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
  makeBinaryWrapper,
  nlohmann_json,
  openssl,
  pkg-config,
  speexdsp,
  versionCheckHook,
  zlib,
  zstd,

  withDiscordRpc ? false,
  verifyAssets ? true,
  # Paths to RCT1 and RCT2 installs can be specified to have them added as a wrapped argument
  rct1Path ? null,
  rct2Path ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrct2";
  version = "0.5.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NzPkrPQ8XIekFfTzPwHnR1skhKv530x80YBZ5fvTRqw=";
  };

  passthru = {
    updateScript = ./update.sh;

    objects-version = "1.7.11";
    openmusic-version = "1.6.1";
    opensfx-version = "1.0.6";
    title-sequences-version = "0.4.26";

    assets = {
      objects = fetchurl {
        url = "https://github.com/OpenRCT2/objects/releases/download/v${finalAttrs.passthru.objects-version}/objects.zip";
        hash = "sha256-dOc7vQEjOVEbs1ndD7sUj9qJl5CuN9fWmGHYgYOxlFI=";
      };
      openmusic = fetchurl {
        url = "https://github.com/OpenRCT2/OpenMusic/releases/download/v${finalAttrs.passthru.openmusic-version}/openmusic.zip";
        hash = "sha256-mUs1DTsYDuHLlhn+J/frrjoaUjKEDEvUeonzP6id4aE=";
      };
      opensfx = fetchurl {
        url = "https://github.com/OpenRCT2/OpenSoundEffects/releases/download/v${finalAttrs.passthru.opensfx-version}/opensound.zip";
        hash = "sha256-BrkPPhnCFnUt9EHVUbJqnj4bp3Vb3SECUEtzv5k2CL4=";
      };
      title-sequences = fetchurl {
        url = "https://github.com/OpenRCT2/title-sequences/releases/download/v${finalAttrs.passthru.title-sequences-version}/title-sequences.zip";
        hash = "sha256-2ruXh7FXY0L8pN2fZLP4z6BKfmzpwruWEPR7dikFyFg=";
      };
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    unzip
    makeWrapper
    makeBinaryWrapper
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
    zstd
  ]
  ++ lib.optional withDiscordRpc discord-rpc;

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_OBJECTS" false)
    (lib.cmakeBool "DOWNLOAD_OPENMUSIC" false)
    (lib.cmakeBool "DOWNLOAD_OPENSFX" false)
    (lib.cmakeBool "DOWNLOAD_TITLE_SEQUENCES" false)
    (lib.cmakeBool "DISABLE_DISCORD_RPC" (!withDiscordRpc))
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "MACOS_USE_DEPENDENCIES" false)
    (lib.cmakeBool "MACOS_BUNDLE" true)
  ];

  postUnpack = ''
    export OPENRCT2_ASSETS_DIR=$sourceRoot/${if stdenv.hostPlatform.isDarwin then "build" else "data"}
    mkdir -p $OPENRCT2_ASSETS_DIR/{object,sequence}
    unzip -o ${finalAttrs.passthru.assets.objects} -d $OPENRCT2_ASSETS_DIR/object
    unzip -o ${finalAttrs.passthru.assets.openmusic} -d $OPENRCT2_ASSETS_DIR
    unzip -o ${finalAttrs.passthru.assets.opensfx} -d $OPENRCT2_ASSETS_DIR
    unzip -o ${finalAttrs.passthru.assets.title-sequences} -d $OPENRCT2_ASSETS_DIR/sequence
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    printf '%s' "${finalAttrs.passthru.assets.objects.url}" > $sourceRoot/build/object/objects.zip.zipversion
    printf '%s' "${finalAttrs.passthru.assets.title-sequences.url}" > $sourceRoot/build/sequence/title-sequences.zip.zipversion
    printf '%s' "${finalAttrs.passthru.assets.opensfx.url}" > $sourceRoot/build/opensound.zip.zipversion
    printf '%s' "${finalAttrs.passthru.assets.openmusic.url}" > $sourceRoot/build/openmusic.zip.zipversion
  '';

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # MACOS_BUNDLE (to build a .APP) is tied to MACOS_USE_DEPENDENCIES by default.
    # Decouple the two variables so that we can use resources downloaded from Nix.
    sed -i \
      -e 's/^CMAKE_DEPENDENT_OPTION(MACOS_BUNDLE.*/option(MACOS_BUNDLE "Build macOS application bundle (OpenRCT2.app)" ON)/' \
      -e '/"MACOS_USE_DEPENDENCIES; NOT DISABLE_GUI" OFF)/d' \
      CMakeLists.txt
    sed -i '/^if (MACOS_USE_DEPENDENCIES)$/i include(cmake/download.cmake)' CMakeLists.txt

    # Clang 21 on Nixpkgs will provide a broken Foundation module, as of now.
    # The Apple Obj-C modules requested are not explicitly required, so drop them.
    substituteInPlace src/{openrct2,openrct2-ui}/CmakeLists.txt \
        --replace-fail '-x objective-c++ -fmodules' \
                       '-x objective-c++'

    # `fixup_bundle` will inherit mismatched dependencies relative to compilation.
    # Hence, disable `fixup_bundle` for Darwin builds.
    substituteInPlace src/openrct2-ui/CMakeLists.txt \
        --replace-fail 'fixup_bundle(''${CMAKE_BINARY_DIR}/''${MACOS_APP_NAME} \"\" \"\")' \
                       '# fixup_bundle disabled for Nix builds'

    # sdl2-compat is the default for SDL2 in Nixpkgs, which has issues on Darwin.
    # Set OpenGL as the default renderer in Darwin to bypass them.
    substituteInPlace src/openrct2/config/Config.cpp \
        --replace-fail 'DrawingEngine::SoftwareWithHardwareDisplay, Enum_DrawingEngine)' \
                       'DrawingEngine::OpenGL, Enum_DrawingEngine)'

    # Wrapping with --rct*-data-path will not work on Darwin for OpenRCT2.app.
    # This simply sets that data path as the default in source, if defined.
    ${lib.optionalString (rct1Path != null) ''
      substituteInPlace src/openrct2/config/Config.cpp \
          --replace-fail 'GetString("rct1_path", "")' 'GetString("rct1_path", "${rct1Path}")'
    ''}
    ${lib.optionalString (rct2Path != null) ''
      substituteInPlace src/openrct2/config/Config.cpp \
          --replace-fail 'GetString("rct2_path", "")' 'GetString("rct2_path", "${rct2Path}")'
    ''}
  '';

  preConfigure =
    # Verify that the correct version of each third party repository is used.
    lib.optionalString verifyAssets (
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (assetName: asset: ''
          grep -qF '"${asset.url}"' assets.json \
            || (echo "${assetName} differs from expected version!"; exit 1)
        '') finalAttrs.passthru.assets
      )
    );

  doInstallCheck = true;

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/{Applications,bin,share}
        cp -R OpenRCT2.app $out/Applications/
        makeBinaryWrapper $out/Applications/OpenRCT2.app/Contents/MacOS/openrct2 $out/bin/openrct2
        cp openrct2-cli $out/bin/openrct2-cli
        ln -s $out/Applications/OpenRCT2.app/Contents/Resources $out/share/openrct2
      ''
    else
      ''
        wrapProgram $out/bin/openrct2 \
          ${lib.optionalString (rct1Path != null) "--add-flags '--rct1-data-path=\"${rct1Path}\"'"} \
          ${lib.optionalString (rct2Path != null) "--add-flags '--rct2-data-path=\"${rct2Path}\"'"}
      '';

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
      schrobingus
    ];
    mainProgram = "openrct2";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
