{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  nodejs_26,
  nodejs-slim_26,
  fetchNpmDeps,
  npmHooks,
  qt6,
  ffmpeg,
  fontconfig,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rhine-music";
  version = "0.4.0-unstable-2026-11-12";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MikeQu223";
    repo = "Rhine-Music-Database";
    rev = "f1eee7637690192bc87d1c84ce2962f605ce429f";
    hash = "sha256-hYo8zW0caMTJRyFREq+0gGrHMQ6sO58jkg65mLnyc/Q=";
  };

  npmDeps = fetchNpmDeps {
    name = "rhine-music-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-FhQS3SNK31NFf4UuVMXcaEbt6ZL4K/S9fi3/khPENJI=";
  };

  bridgeDeps = fetchNpmDeps {
    name = "rhine-music-bridge-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "source/MusicBridge";
    hash = "sha256-eCDn6FbpKv0E7LtGP3Om7Hl9UMcgqeaKli3njVdzJP0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    nodejs_26
    npmHooks.npmConfigHook
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];
  buildInputs = with qt6; [
    qtbase
    qtdeclarative
    qtshadertools
    qtmultimedia
    qtwayland
    qtsvg
    qtimageformats
  ];
  npmFlags = [ "--ignore-scripts" ];

  preConfigure = ''
    npm ci --prefix MusicBridge --cache ${finalAttrs.bridgeDeps} --offline \
      --ignore-scripts --omit=dev --no-audit --no-fund
    python3 scripts/check-qt-project.py
    python3 scripts/export-assets.py
    python3 scripts/bake-archive-lighting.py
    cp Assets/fonts/* output/resources/
    node scripts/bundle-bridge.cjs MusicBridge output/bridge-build
    mkdir -p output/resources/MusicBridge
    cp MusicBridge/lyrics-source.json MusicBridge/LyricsKit-LICENSE output/resources/MusicBridge/
    tar -xOf ${nodejs-slim_26.src} node-v${nodejs_26.version}/LICENSE \
      > output/resources/MusicBridge/NODE-LICENSE
    ln -s ${nodejs_26}/bin/node output/resources/MusicBridge/node
    node scripts/package-resources.cjs output/native-resources
    rm output/native-resources/MusicBridge/node
    ln -s ${nodejs_26}/bin/node output/native-resources/MusicBridge/node
    cp -r output/bridge-build/MusicBridge/. output/resources/MusicBridge/
  '';

  cmakeFlags = [ "-DRHINE_ENABLE_FIDELITYFX=OFF" ];
  enableParallelBuilding = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    export HOME="$TMPDIR/rhine-test-home"
    export XDG_RUNTIME_DIR="$TMPDIR/rhine-runtime"
    mkdir -p "$HOME" "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    export QT_QPA_PLATFORM=offscreen
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
    export QT_PLUGIN_PATH="${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtmultimedia}/${qt6.qtbase.qtPluginPrefix}"
    export QML2_IMPORT_PATH="${qt6.qtdeclarative}/${qt6.qtbase.qtQmlPrefix}:${qt6.qtmultimedia}/${qt6.qtbase.qtQmlPrefix}"
    ctest --output-on-failure --timeout 120 \
      -R '^qt_(offline|playback_queue_regression)$'
    node ../scripts/check-packaged-core.cjs ../output/native-resources/MusicBridge
    node ../Qt/tests/local-lyrics.cjs ../output/native-resources/MusicBridge
    runHook postCheck
  '';

  postInstall = ''
    # Vendored libraries are linked statically; their development files are not needed.
    rm -rf "$out/include" "$out/lib/cmake" "$out/lib/pkgconfig" "$out/share/utf8cpp"
    rm -f "$out/bin/taglib-config" "$out/lib/libtag.a"
    mkdir -p "$out/share/rhine-music-database" "$out/lib"
    cp -r ../output/native-resources/. "$out/share/rhine-music-database/"
    install -Dm644 ../LICENSE "$out/share/rhine-music-database/LICENSE"
    cp -r ../vendor/taglib ../vendor/utfcpp "$out/share/rhine-music-database/"
    ln -s ${lib.getLib ffmpeg}/lib/libswresample.so.* "$out/lib/"
    ln -s ${lib.getLib ffmpeg}/lib/libavutil.so.* "$out/lib/"
    install -Dm644 ../Assets/icons/icon-256.png \
      "$out/share/icons/hicolor/256x256/apps/rhine-music-database.png"
  '';
  preFixup = ''
    qtWrapperArgs+=(--set-default RHINE_RESOURCES "$out/share/rhine-music-database")
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "rhine-music-database";
      desktopName = "Rhine Music Database";
      exec = "RhineMusicDatabase";
      icon = "rhine-music-database";
      categories = [
        "AudioVideo"
        "Audio"
        "Player"
      ];
    })
  ];

  meta = {
    description = "Rhine Lab inspired desktop music player";
    homepage = "https://github.com/MikeQu223/Rhine-Music-Database";
    license = with lib.licenses; [
      mit
      mpl11
      mpl20
      boost
      ofl
      unfree
    ];
    maintainers = with lib.maintainers; [ Booker786 ];
    mainProgram = "RhineMusicDatabase";
    platforms = [ "x86_64-linux" ];
    # Resource distribution rights remain unresolved.
    hydraPlatforms = [ ];
  };
})
