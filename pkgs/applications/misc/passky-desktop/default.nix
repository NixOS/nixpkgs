{ lib, stdenv, fetchurl, appimageTools, undmg }:

let
  pname = "passky-desktop";
  version = "5.0.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/Rabbit-Company/Passky-Desktop/releases/download/v${version}/Passky-${version}.AppImage";
      sha256 = "19sy9y2bcxrf10ifszinh4yn32q3032h3d1qxm046zffzl069807";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/Rabbit-Company/Passky-Desktop/releases/download/v${version}/Passky-${version}.dmg";
      sha256 = "sha256-lclJOaYe+2XeKhJb2WcOAzjBMzK3YEmlS4rXuRUJYU0=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  appimageContents = appimageTools.extract { inherit pname version src; };
  meta = with lib; {
    homepage = "https://passky.org";
    downloadPage = "https://github.com/Rabbit-Company/Passky-Desktop/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ akkesm ];
    platforms = builtins.attrNames srcs;
  };

  linux = appimageTools.wrapType2 {
    inherit pname version src meta;

    extraInstallCommands = ''
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      install -D ${appimageContents}/passky.desktop \
        $out/share/applications/${pname}.desktop

      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'

      cp -r ${appimageContents}/usr/share/icons $out/share
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
