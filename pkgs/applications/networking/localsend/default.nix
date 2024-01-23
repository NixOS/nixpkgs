{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, flutter313
, makeDesktopItem
, pkg-config
, libayatana-appindicator
, undmg
}:

let
  pname = "localsend";
  version = "1.13.1";

  linux = flutter313.buildFlutterApplication {
    inherit pname version;

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      hash = "sha256-GJHCKNtKvwQAG3AUkhk0G4k/qsmLOUQAyyi9Id7NJh8=";
    };

    sourceRoot = "source/app";

    pubspecLock = lib.importJSON ./pubspec.lock.json;

    gitHashes = {
      "permission_handler_windows" = "sha256-a7bN7/A65xsvnQGXUvZCfKGtslbNWEwTWR8fAIjMwS0=";
      "tray_manager" = "sha256-eF14JGf5jclsKdXfCE7Rcvp72iuWd9wuSZ8Bej17tjg=";
    };

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [ libayatana-appindicator ];

    postInstall = ''
      for s in 32 128 256 512; do
        d=$out/share/icons/hicolor/''${s}x''${s}/apps
        mkdir -p $d
        ln -s $out/app/data/flutter_assets/assets/img/logo-''${s}.png $d/localsend.png
      done
      mkdir -p $out/share/applications
      cp $desktopItem/share/applications/*.desktop $out/share/applications
      substituteInPlace $out/share/applications/*.desktop --subst-var out
    '';

    desktopItem = makeDesktopItem {
      name = "LocalSend";
      exec = "@out@/bin/localsend_app";
      icon = "localsend";
      desktopName = "LocalSend";
      startupWMClass = "localsend_app";
      genericName = "An open source cross-platform alternative to AirDrop";
      categories = [ "Network" ];
    };

    meta = meta // {
      mainProgram = "localsend_app";
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/localsend/localsend/releases/download/v${version}/LocalSend-${version}.dmg";
      hash = "sha256-YCy6NlmEPsOFtIZ27mOYDnMPd1tj3YO2bwNDdM3K/uY=";
    };

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';

    meta = meta // {
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    };
  };

  meta = with lib; {
    description = "An open source cross-platform alternative to AirDrop";
    homepage = "https://localsend.org/";
    license = licenses.mit;
    mainProgram = "localsend";
    maintainers = with maintainers; [ sikmir linsui ];
  };
in
if stdenv.isDarwin
then darwin
else linux
