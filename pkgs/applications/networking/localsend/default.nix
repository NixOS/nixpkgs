{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, flutter313
, makeDesktopItem
, pkg-config
, libayatana-appindicator
, undmg
, makeBinaryWrapper
}:

let
  pname = "localsend";
  version = "1.14.0";

  linux = flutter313.buildFlutterApplication rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      hash = "sha256-CO0uFcZnOfE31EZxRUpgtod3+1lyXPpbytHB45DEM98=";
    };

    sourceRoot = "${src.name}/app";

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

    passthru.updateScript = ./update.sh;

    meta = metaCommon // {
      mainProgram = "localsend_app";
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/localsend/localsend/releases/download/v${version}/LocalSend-${version}.dmg";
      hash = "sha256-L7V48QoOA0cjx45n+9Xav/zzCzCsZB3TBip0WGusMXg=";
    };

    nativeBuildInputs = [ undmg makeBinaryWrapper ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
      makeBinaryWrapper $out/Applications/LocalSend.app/Contents/MacOS/LocalSend $out/bin/localsend
    '';

    meta = metaCommon // {
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    };
  };

  metaCommon = with lib; {
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
