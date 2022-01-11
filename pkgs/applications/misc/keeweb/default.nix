{ lib, stdenv, fetchurl, appimageTools, undmg, libsecret, libxshmfence }:
let
  pname = "keeweb";
  version = "1.18.6";
  name = "${pname}-${version}";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.linux.AppImage";
      sha256 = "sha256-hxXs8Dfh5YQy1zaFb20KDWNl8eqFjuN5QY7tsO6+E/U=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.mac.x64.dmg";
      sha256 = "sha256-8+7NzaHVcLinKb57SAcJmF2Foy9RfxFhcTxzvL0JSJQ=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/keeweb/keeweb/releases/download/v${version}/KeeWeb-${version}.mac.arm64.dmg";
      sha256 = "sha256-1BNY6kRS0F+AUI+80ZGFi/ek28NMP1uexo1UORz5D6g=";
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
        --replace 'Exec=AppRun' 'Exec=${pname}'
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
