{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  flutter329,
  makeDesktopItem,
  copyDesktopItems,
  nixosTests,
  libayatana-appindicator,
  undmg,
  makeBinaryWrapper,
  fetchpatch,
  roboto,
}:

let
  pname = "localsend";
  version = "1.17.0";

  linux = flutter329.buildFlutterApplication rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "localsend";
      repo = "localsend";
      tag = "v${version}";
      hash = "sha256-1xMzlIcGEJ58laSM48bCKMxzHQ36eUHD5Mac0O1dnXk=";
    };

    sourceRoot = "${src.name}/app";

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = {
      permission_handler_windows = "sha256-+TP3neqlQRZnW6BxHaXr2EbmdITIx1Yo7AEn5iwAhwM=";
      pasteboard = "sha256-lJA5OWoAHfxORqWMglKzhsL1IFr9YcdAQP/NVOLYB4o=";
    };

    patches = [
      # Fix for https://github.com/localsend/localsend/security/advisories/GHSA-34v6-52hh-x4r4
      # See: https://github.com/NixOS/nixpkgs/issues/488755
      # Can be removed with new release > 1.17.0
      (fetchpatch {
        url = "https://github.com/localsend/localsend/commit/8f3cec85aa29b2b13fed9b2f8e499e1ac9b0504c.patch";
        hash = "sha256-Fswir+TebCDPxHVBg8YM3ROx2uoLG92E3E15wnzHz+U=";
      })
    ];

    patchFlags = [ "-p2" ];

    postPatch = ''
      substituteInPlace lib/util/native/autostart_helper.dart \
        --replace-fail 'Exec=''${Platform.resolvedExecutable}' "Exec=localsend_app"
    ''
    # On aarch64-linux the Flutter engine fails to load the platform font, so
    # all text renders blank while bundled font assets (e.g. the MaterialIcons
    # glyphs) draw fine (https://github.com/localsend/localsend/issues/2873).
    # Bundle Roboto as an app asset and use it as the default font family, so
    # text is drawn from a bundled font exactly like the icons.
    + lib.optionalString stdenv.hostPlatform.isAarch64 ''
      mkdir -p fonts
      cp ${roboto}/share/fonts/truetype/Roboto-Regular.ttf fonts/
      cp ${roboto}/share/fonts/truetype/Roboto-Medium.ttf fonts/
      cp ${roboto}/share/fonts/truetype/Roboto-Bold.ttf fonts/
      cp ${roboto}/share/fonts/truetype/Roboto-Italic.ttf fonts/
      cp ${roboto}/share/fonts/truetype/Roboto-BoldItalic.ttf fonts/

      substituteInPlace pubspec.yaml \
        --replace-fail '  uses-material-design: true' '  uses-material-design: true
        fonts:
          - family: Roboto
            fonts:
              - asset: fonts/Roboto-Regular.ttf
              - asset: fonts/Roboto-Medium.ttf
                weight: 500
              - asset: fonts/Roboto-Bold.ttf
                weight: 700
              - asset: fonts/Roboto-Italic.ttf
                style: italic
              - asset: fonts/Roboto-BoldItalic.ttf
                weight: 700
                style: italic'

      substituteInPlace lib/config/theme.dart \
        --replace-fail 'fontFamily = null;' "fontFamily = 'Roboto';"
    '';

    nativeBuildInputs = [
      copyDesktopItems
    ];

    buildInputs = [ libayatana-appindicator ];

    postInstall = ''
      for s in 32 128 256 512; do
        d=$out/share/icons/hicolor/''${s}x''${s}/apps
        mkdir -p $d
        cp ./assets/img/logo-''${s}.png $d/localsend.png
      done
    '';

    extraWrapProgramArgs = ''
      --prefix LD_LIBRARY_PATH : $out/app/localsend/lib
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "LocalSend";
        exec = "localsend_app %U";
        icon = "localsend";
        desktopName = "LocalSend";
        startupWMClass = "localsend_app";
        genericName = "An open source cross-platform alternative to AirDrop";
        categories = [
          "GTK"
          "FileTransfer"
          "Utility"
        ];
        keywords = [
          "Sharing"
          "LAN"
          "Files"
        ];
        startupNotify = true;
      })
    ];

    passthru = {
      updateScript = ./update.sh;
      tests.localsend = nixosTests.localsend;
    };

    meta = metaCommon // {
      mainProgram = "localsend_app";
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/localsend/localsend/releases/download/v${version}/LocalSend-${version}.dmg";
      hash = "sha256-/fGkLuE+uf3WrpTcWIOYHooJWZ51i94j9uZ3xPq1yTw=";
    };

    nativeBuildInputs = [
      undmg
      makeBinaryWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r LocalSend.app $out/Applications
      makeBinaryWrapper $out/Applications/LocalSend.app/Contents/MacOS/LocalSend $out/bin/localsend

      runHook postInstall
    '';

    meta = metaCommon // {
      mainProgram = "localsend";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    };
  };

  metaCommon = {
    description = "Open source cross-platform alternative to AirDrop";
    homepage = "https://localsend.org/";
    donationPage = "https://localsend.org/donate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sikmir
      linsui
      pandapip1
    ];
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
