{ lib
, stdenv
, fetchurl
, fetchFromGitHub
, flutter
, makeDesktopItem
, pkg-config
, libayatana-appindicator
, undmg
}:

let
  pname = "localsend";
  version = "1.12.0";

  linux = flutter.buildFlutterApplication {
    inherit pname version;

    src = fetchFromGitHub {
      owner = pname;
      repo = pname;
      rev = "v${version}";
      hash = "sha256-mk0CLZP0x/mEixeAig7X41aFgQzs+kZkBJx6T//3ZKY=";
    };

    sourceRoot = "source/app";
    depsListFile = ./deps.json;
    vendorHash = "sha256-fXzxT7KBi/WT2A5PEIx+B+UG4HWEbMPMsashVQsXdmU=";

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
      startupWMClass = "localsend";
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
      hash = "sha256-XKYc3lA7x0Tf1Mf3o7D2RYwYDRDVHoSb/lj9PhKzV5U=";
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
    maintainers = with maintainers; [ sikmir ];
  };
in
if stdenv.isDarwin
then darwin
else linux
