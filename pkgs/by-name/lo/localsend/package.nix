{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  flutter324,
  makeDesktopItem,
  copyDesktopItems,
  nixosTests,
  libayatana-appindicator,
  undmg,
  makeBinaryWrapper,
}:

let
  pname = "localsend";
  version = "1.16.1";

  linux = flutter324.buildFlutterApplication rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "localsend";
      repo = "localsend";
      tag = "v${version}";
      hash = "sha256-9nW1cynvRgX565ZupR+ogfDH9Qem+LQH4XZupVsrEWo=";
    };

    sourceRoot = "${src.name}/app";

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = {
      permission_handler_windows = "sha256-+TP3neqlQRZnW6BxHaXr2EbmdITIx1Yo7AEn5iwAhwM=";
      pasteboard = "sha256-lJA5OWoAHfxORqWMglKzhsL1IFr9YcdAQP/NVOLYB4o=";
    };

    postPatch = ''
      substituteInPlace lib/util/native/autostart_helper.dart \
        --replace-fail 'Exec=''${Platform.resolvedExecutable}' "Exec=localsend_app"
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
      hash = "sha256-kgq3AoypDdRwk9bKa1zjUJo4tHHUbDZIg0G0Rk9S3n4=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sikmir
      linsui
      pandapip1
    ];
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
