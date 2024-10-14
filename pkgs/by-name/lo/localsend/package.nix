{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  flutter324,
  makeDesktopItem,
  nixosTests,
  pkg-config,
  libayatana-appindicator,
  undmg,
  makeBinaryWrapper,
}:

let
  pname = "localsend";
  version = "1.15.4";

  linux = flutter324.buildFlutterApplication rec {
    inherit pname;
    version = "1.15.4-unstable-2024-09-25";

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "61f3ffdb8dd8b1116ced2e7b585f2f6662ce7d5f";
      hash = "sha256-s7cR5ty8bygOCzHbLwNTBNlhlQ+2y25/ijlNqWYrqVw=";
    };

    sourceRoot = "${src.name}/app";

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = {
      "permission_handler_windows" = "sha256-+TP3neqlQRZnW6BxHaXr2EbmdITIx1Yo7AEn5iwAhwM=";
    };

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [ libayatana-appindicator ];

    postUnpack = ''
      substituteInPlace $sourceRoot/linux/my_application.cc \
        --replace-fail "gtk_widget_realize(GTK_WIDGET(window))" "gtk_widget_show(GTK_WIDGET(window))"
    '';

    postInstall = ''
      for s in 32 128 256 512; do
        d=$out/share/icons/hicolor/''${s}x''${s}/apps
        mkdir -p $d
        ln -s $out/app/data/flutter_assets/assets/img/logo-''${s}.png $d/localsend.png
      done
      mkdir -p $out/share/applications
      cp $desktopItem/share/applications/*.desktop $out/share/applications
    '';

    desktopItem = makeDesktopItem {
      name = "LocalSend";
      exec = "localsend_app";
      icon = "localsend";
      desktopName = "LocalSend";
      startupWMClass = "localsend_app";
      genericName = "An open source cross-platform alternative to AirDrop";
      categories = [ "Network" ];
    };

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
      hash = "sha256-ZU2aXZNKo01TnXNH0e+r0l4J5HIILmGam3T4+6GaeA4=";
    };

    nativeBuildInputs = [
      undmg
      makeBinaryWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
      makeBinaryWrapper $out/Applications/LocalSend.app/Contents/MacOS/LocalSend $out/bin/localsend
    '';

    meta = metaCommon // {
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
    mainProgram = "localsend";
    maintainers = with lib.maintainers; [
      sikmir
      linsui
      pandapip1
    ];
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
