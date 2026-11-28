{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  nodejs-slim,
  fetchNpmDeps,
  cmake,
  ninja,
  pkg-config,
  python3,
  qt6,
  ffmpeg,
  fontconfig,
  makeDesktopItem,
  copyDesktopItems,
  ctestCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "rhine-music";
  version = "1.3.25";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MikeQu223";
    repo = "Rhine-Music-Database";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f3Bjojbyb7lupOwG7VrtnnRHudYBlrBnFc6wVuHpLgY=";
  };

  npmDepsHash = "sha256-FhQS3SNK31NFf4UuVMXcaEbt6ZL4K/S9fi3/khPENJI=";
  dontNpmBuild = true;
  dontNpmInstall = true;
  dontStrip = false;

  bridgeDeps = fetchNpmDeps {
    name = "rhine-music-bridge-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/MusicBridge";
    hash = "sha256-eCDn6FbpKv0E7LtGP3Om7Hl9UMcgqeaKli3njVdzJP0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
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
    (npmRoot=MusicBridge npmDeps=${finalAttrs.bridgeDeps} npmConfigHook)
    python3 scripts/check-qt-project.py
    python3 scripts/export-assets.py
    python3 scripts/bake-archive-lighting.py
    cp Assets/fonts/* output/resources/
    node scripts/bundle-bridge.cjs MusicBridge output/bridge-build
    mkdir -p output/resources/MusicBridge
    cp MusicBridge/lyrics-source.json MusicBridge/LyricsKit-LICENSE output/resources/MusicBridge/
    tar -xOf ${nodejs-slim.src} node-v${nodejs.version}/LICENSE \
      > output/resources/MusicBridge/NODE-LICENSE
    ln -s ${nodejs}/bin/node output/resources/MusicBridge/node
    node scripts/package-resources.cjs output/native-resources
    rm output/native-resources/MusicBridge/node
    ln -s ${nodejs}/bin/node output/native-resources/MusicBridge/node
    cp -r output/bridge-build/MusicBridge/. output/resources/MusicBridge/
  '';

  cmakeFlags = [
    (lib.cmakeFeature "RHINE_VERSION" finalAttrs.version)
    (lib.cmakeBool "RHINE_RELEASE_BUILD" true)
    (lib.cmakeBool "RHINE_ENABLE_FIDELITYFX" false)
  ];

  doCheck = true;
  dontUseNinjaCheck = true;
  enableParallelChecking = false;

  nativeCheckInputs = [
    ctestCheckHook
    fontconfig
    writableTmpDirAsHomeHook
  ];

  ctestFlags = [
    "--timeout"
    "120"
    "-R"
    "^qt_(offline|storage_regression|playback_queue_regression|transition_analysis_regression)$"
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR="$(mktemp -d)"
    export QT_QPA_PLATFORM=offscreen
    export FONTCONFIG_FILE="${fontconfig.out}/etc/fonts/fonts.conf"
    export QT_PLUGIN_PATH="${
      lib.makeSearchPath qt6.qtbase.qtPluginPrefix [
        qt6.qtbase
        qt6.qtmultimedia
      ]
    }"
    export QML2_IMPORT_PATH="${
      lib.makeSearchPath qt6.qtbase.qtQmlPrefix [
        qt6.qtdeclarative
        qt6.qtmultimedia
      ]
    }"
  '';

  postCheck = ''
    node ../scripts/check-packaged-core.cjs ../output/native-resources/MusicBridge
    node ../Qt/tests/local-lyrics.cjs ../output/native-resources/MusicBridge
  '';

  postInstall = ''
    # Vendored libraries are linked statically; their development files are not needed.
    rm -rf "$out/include" "$out/lib/cmake" "$out/lib/pkgconfig" "$out/share/utf8cpp"
    rm -f "$out/bin/taglib-config" "$out/lib/libtag.a"
    resources="$out/share/rhine-music-database"
    mkdir -p "$resources/third-party/taglib" "$resources/third-party/utfcpp" "$out/lib"
    cp -r ../output/native-resources/. "$resources/"
    install -Dm644 ../LICENSE "$resources/LICENSE"
    install -Dm644 ../vendor/qrcodegen/qrcodegen.hpp "$resources/qrcodegen-LICENSE.hpp"
    cp -r ../licenses/Qt "$resources/Qt-Licenses"
    install -Dm644 ../vendor/taglib/COPYING.LGPL ../vendor/taglib/COPYING.MPL ../vendor/taglib/source.json \
      -t "$resources/third-party/taglib"
    install -Dm644 ../vendor/utfcpp/LICENSE ../vendor/utfcpp/source.json \
      -t "$resources/third-party/utfcpp"
    ln -s ${lib.getLib ffmpeg}/lib/libswresample.so.* "$out/lib/"
    ln -s ${lib.getLib ffmpeg}/lib/libavutil.so.* "$out/lib/"
    for size in 16 32 64 128 256 512 1024; do
      install -Dm644 "../Assets/icons/icon-$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/rhine-music-database.png"
    done
  '';

  qtWrapperArgs = [
    "--set-default"
    "RHINE_RESOURCES"
    "${placeholder "out"}/share/rhine-music-database"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "rhine-music-database";
      desktopName = "RHINE MUSIC DATABASE";
      genericName = "Music Library";
      comment = finalAttrs.meta.description;
      exec = "RhineMusicDatabase %U";
      icon = "rhine-music-database";
      terminal = false;
      categories = [
        "AudioVideo"
        "Audio"
        "Player"
      ];
      startupWMClass = "RhineMusicDatabase";
      extraConfig = {
        "Comment[zh_CN]" = "原生音乐资料库";
      };
    })
  ];

  passthru = {
    inherit (finalAttrs) bridgeDeps;
    updateScript = nix-update-script {
      extraArgs = [
        "--custom-dep"
        "bridgeDeps"
      ];
    };
  };

  meta = {
    description = "Rhine Lab inspired desktop music player";
    homepage = "https://github.com/MikeQu223/Rhine-Music-Database";
    changelog = "https://github.com/MikeQu223/Rhine-Music-Database/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit # Rhine-Music-Database, qrcodegen, Three.js, nodejs-mobile
      mpl11 # vendor/taglib (dual-licensed MPL-1.1 / LGPL-2.1)
      lgpl21Only # vendor/taglib, FFmpeg
      mpl20 # MusicBridge/lyrics-format.cjs (LyricsKit)
      boost # vendor/utfcpp (BSL-1.0)
      ofl # Noto Sans Symbols 2 font
      unfree # MiSans font and Arknights-derived assets
    ];
    maintainers = with lib.maintainers; [ Booker786 ];
    mainProgram = "RhineMusicDatabase";
    platforms = lib.platforms.linux;
    # Resource distribution rights remain unresolved.
    hydraPlatforms = [ ];
  };
})
