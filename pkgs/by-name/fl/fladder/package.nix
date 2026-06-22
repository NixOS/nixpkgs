{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  flutter335,
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
  flutter = flutter335;
  sourceBuild = flutter.buildFlutterApplication (finalAttrs: {
    pname = "fladder";
    version = "0.10.3";

    src = fetchFromGitHub {
      owner = "DonutWare";
      repo = "Fladder";
      tag = "v${finalAttrs.version}";
      hash = "sha256-0eFHylRi2UVaKRG7K3tDZVscgoiL5xFrtFhZiJxj4Mk=";
    };

    inherit targetFlutterPlatform;

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = lib.importJSON ./git-hashes.json;

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
        exec = "Fladder";
        icon = "fladder";
        comment = "Simple Jellyfin Frontend built on top of Flutter";
        categories = [
          "AudioVideo"
          "Video"
          "Player"
        ];
      })
    ];

    passthru.updateScript = ./update.sh;

    meta = {
      description = "Simple Jellyfin Frontend built on top of Flutter";
      homepage = "https://github.com/DonutWare/Fladder";
      downloadPage = "https://github.com/DonutWare/Fladder/releases";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        ratcornu
        schembriaiden
      ];
      mainProgram = "Fladder";
    };
  });

  darwin = stdenv.mkDerivation {
    pname = sourceBuild.pname;
    inherit (sourceBuild) version;

    src = fetchurl {
      url = "https://github.com/DonutWare/Fladder/releases/download/v${sourceBuild.version}/Fladder-macOS-${sourceBuild.version}.dmg";
      hash = "sha256-Vnz0jtmDptcrehE7DrgyTzFJJopirsLaO+lu1V/Xd+o=";
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
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = lib.platforms.darwin;
    };
  };
in
if stdenv.hostPlatform.isDarwin then darwin else sourceBuild
