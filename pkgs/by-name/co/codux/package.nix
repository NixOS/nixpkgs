{ lib
, appimageTools
, fetchurl
}:

let
  pname = "codux";
  version = "15.29.1";

  src = fetchurl {
    url = "https://github.com/wixplosives/codux-versions/releases/download/${version}/Codux-${version}.x86_64.AppImage";
    sha256 = "sha256-wiAME0jNtqGbMk6w1jzKUZUzhS0Gg5FgqXD1vuRSpxo=";
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
