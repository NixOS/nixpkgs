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
    version = "0.11.0";

    src = fetchFromGitHub {
      owner = "DonutWare";
      repo = "Fladder";
      tag = "v${finalAttrs.version}";
      hash = "sha256-oE1nlKH//FFVuOXGByX8cL+q6TA29VPJuoKoz2HLO8g=";
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
      hash = "sha256-fl73LdAo0E1qcyE2QCQszAbstcMjWLrp6v1LYK+nPCk=";
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
