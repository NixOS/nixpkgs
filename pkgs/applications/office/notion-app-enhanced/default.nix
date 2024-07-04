{ appimageTools, lib, fetchurl }:
let
  pname = "notion-app-enhanced";
  version = "2.0.18-1";

  src = fetchurl {
    url = "https://github.com/notion-enhancer/notion-repackaged/releases/download/v${version}/Notion-Enhanced-${version}.AppImage";
    sha256 = "sha256-SqeMnoMzxxaViJ3NPccj3kyMc1xvXWULM6hQIDZySWY=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Notion Desktop builds with Notion Enhancer for Windows, MacOS and Linux";
    homepage = "https://github.com/notion-enhancer/desktop";
    license = licenses.unfree;
    maintainers = with maintainers; [ sei40kr ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "notion-app-enhanced";
  };
}
