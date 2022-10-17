{ lib, stdenv, fetchurl, appimageTools, undmg, libsecret, libxshmfence }:
let
  pname = "keeweb";
  version = "1.18.7";
  name = "${pname}-${version}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.linux.AppImage";
      hash = "sha256-W3Dfo7YZfLObodAS7ZN3jqnYzLNAnjJIfJC6il5THwY=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.mac.x64.dmg";
      hash = "sha256-+ZFGrrw0tZ7F6lb/3iBIyGD+tp1puVhkPv10hfp6ATU=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.mac.arm64.dmg";
      hash = "sha256-bkhwsWYLkec16vMOfXUce7jfrmI9W2xHiZvU1asebK4=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system};

  appimageContents = appimageTools.extract {
    inherit name src;
  };

  meta = with lib; {
    description = "Free cross-platform password manager compatible with KeePass";
    homepage = "https://keeweb.info/";
    changelog = "https://github.com/keeweb/keeweb/blob/v${version}/release-notes.md";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = builtins.attrNames srcs;
  };

  linux = appimageTools.wrapType2 rec {
    inherit name src meta;

    extraPkgs = pkgs: with pkgs; [ libsecret libxshmfence ];

    extraInstallCommands = ''
      mv $out/bin/{${name},${pname}}
      install -Dm644 ${appimageContents}/keeweb.desktop -t $out/share/applications
      install -Dm644 ${appimageContents}/keeweb.png -t $out/share/icons/hicolor/256x256/apps
      install -Dm644 ${appimageContents}/usr/share/mime/keeweb.xml -t $out/share/mime
      substituteInPlace $out/share/applications/keeweb.desktop \
        --replace "Exec=AppRun" "Exec=$out/bin/${pname}"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux
