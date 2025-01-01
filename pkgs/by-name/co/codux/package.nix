{ lib
, appimageTools
, fetchurl
}:

let
  pname = "codux";
  version = "15.34.0";

  src = fetchurl {
    url = "https://github.com/wixplosives/codux-versions/releases/download/${version}/Codux-${version}.x86_64.AppImage";
    hash = "sha256-/e5tz3/XD/aaxLc/SUrTmWWfqI2Gw/xBTTTSmv5uZEQ=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in

appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
    substituteInPlace $out/share/applications/${pname}.desktop  --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Visual IDE for React";
    homepage = "https://www.codux.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ dit7ya kashw2 ];
    mainProgram = "codux";
  };
}
