{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  flutter350,
  copyDesktopItems,
  makeDesktopItem,
  undmg,
  makeBinaryWrapper,

  alsa-lib,
  libdisplay-info,
  libxpresent,
  libxscrnsaver,
  libepoxy,
  mpv-unwrapped,

  targetFlutterPlatform ? "linux",
  baseUrl ? null,
}:

let
  flutter = flutter350;
  sourceBuild = flutter.buildFlutterApplication (finalAttrs: {
    pname = "fladder";
    version = "0.12.1";

    src = fetchFromGitHub {
      owner = "DonutWare";
      repo = "Fladder";
      tag = "v${finalAttrs.version}";
      hash = "sha256-fnJ/MuAAEkgwyab9kakp+71t8a37XGwj3WoEnA/hLtg=";
    };

    inherit targetFlutterPlatform;

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = lib.importJSON ./git-hashes.json;

    customSourceBuilders = lib.optionalAttrs (targetFlutterPlatform == "linux") {
      media_kit_video =
        { version, src, ... }:
        stdenv.mkDerivation {
          pname = "media_kit_video";
          inherit version src;
          inherit (src) passthru;

          # Import shared mpv without probing its static dependencies.
          postPatch = ''
            substituteInPlace "${src.passthru.packageRoot}/linux/CMakeLists.txt" \
              --replace-fail 'pkg_check_modules(mpv IMPORTED_TARGET mpv)' 'cmake_pkg_config(IMPORT mpv REQUIRED)' \
              --replace-fail 'target_compile_options(''${PLUGIN_NAME} PRIVATE "''${mpv_CFLAGS_OTHER}")' "" \
              --replace-fail '"''${mpv_INCLUDE_DIRS}"' ""
          '';

          dontBuild = true;
          installPhase = ''
            runHook preInstall
            cp -r . "$out"
            runHook postInstall
          '';
        };
    };

    nativeBuildInputs = lib.optionals (targetFlutterPlatform == "linux") [
      copyDesktopItems
    ];

    buildInputs = [
      alsa-lib
      libdisplay-info
      mpv-unwrapped
      libxpresent
      libxscrnsaver
    ]
    ++ lib.optionals (targetFlutterPlatform == "linux") [
      libepoxy
    ];

    postInstall =
      lib.optionalString (targetFlutterPlatform == "web") (
        ''
          sed -i 's;base href="/";base href="$out";' $out/index.html
        ''
        + lib.optionalString (baseUrl != null) ''
          echo '{"baseUrl": "${baseUrl}"}' > $out/assets/config/config.json
        ''
      )
      + lib.optionalString (targetFlutterPlatform == "linux") ''
        # Install SVG icon
        install -Dm644 icons/fladder_icon.svg \
          $out/share/icons/hicolor/scalable/apps/fladder.svg
      '';

    desktopItems = lib.optionals (targetFlutterPlatform == "linux") [
      (makeDesktopItem {
        name = "fladder";
        desktopName = "Fladder";
        genericName = "Jellyfin Client";
        exec = "fladder";
        icon = "fladder";
        comment = "Cross-platform Jellyfin client built on top of Flutter";
        categories = [
          "AudioVideo"
          "Video"
          "Player"
        ];
      })
    ];

    passthru.updateScript = ./update.sh;

    meta = {
      description = "Cross-platform Jellyfin client built on top of Flutter";
      homepage = "https://github.com/DonutWare/Fladder";
      downloadPage = "https://github.com/DonutWare/Fladder/releases";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        ratcornu
        schembriaiden
      ];
      mainProgram = "fladder";
    };
  });

  darwin = stdenv.mkDerivation {
    pname = sourceBuild.pname;
    inherit (sourceBuild) version;

    src = fetchurl {
      url = "https://github.com/DonutWare/Fladder/releases/download/v${sourceBuild.version}/Fladder-macOS-${sourceBuild.version}.dmg";
      hash = "sha256-Ro8JXV4SwJUHZvR433iSB8reSrYts/AFsrzUSKeSD44=";
    };

    nativeBuildInputs = [
      undmg
      makeBinaryWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r Fladder.app $out/Applications
      makeBinaryWrapper $out/Applications/Fladder.app/Contents/MacOS/Fladder $out/bin/Fladder

      runHook postInstall
    '';

    meta = sourceBuild.meta // {
      mainProgram = "Fladder";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = lib.platforms.darwin;
    };
  };
in
if stdenv.hostPlatform.isDarwin then darwin else sourceBuild
