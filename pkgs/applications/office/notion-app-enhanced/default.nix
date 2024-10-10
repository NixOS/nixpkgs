{ appimageTools, lib, fetchurl, asar, dos2unix }:
let
  pname = "notion-app-enhanced";
  version = "2.0.18-1";

  src = fetchurl {
    url = "https://github.com/notion-enhancer/notion-repackaged/releases/download/v${version}/Notion-Enhanced-${version}.AppImage";
    sha256 = "sha256-SqeMnoMzxxaViJ3NPccj3kyMc1xvXWULM6hQIDZySWY=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      # fix https://github.com/notion-enhancer/notion-enhancer/issues/812
      ${asar}/bin/asar extract $out/resources/app.asar app
      ${dos2unix}/bin/dos2unix app/renderer/preload.js
      patch app/renderer/preload.js ${./notion-infinite-load-fix.patch}
      ${dos2unix}/bin/unix2dos app/renderer/preload.js
      ${asar}/bin/asar pack app $out/resources/app.asar
    '';
  };
  # wrapAppImage instead of wrapType2 to avoid re-extracting the AppImage
in appimageTools.wrapAppImage {
  inherit pname version;

  src = appimageContents;

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
