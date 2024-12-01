{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "chatbox";
  version = "1.6.1";

  src = fetchurl {
    url = "https://download.chatboxai.app/releases/Chatbox-${version}-x86_64.AppImage";
    hash = "sha256-Gr7Un5K0AJFRzy9IMYAWmn66dijsWtKwrS/o/UW4Zrk=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/xyz.chatboxapp.app.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/xyz.chatboxapp.app.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
      --replace-fail 'Icon=xyz.chatboxapp.app' 'Icon=${pname}'
  '';

  meta = {
    description = "Chatbox AI is an AI client application and smart assistant.";
    homepage = "https://chatboxai.app";
    downloadPage = "https://chatboxai.app/en#download";
    changelog = "https://chatboxai.app/en/help-center/changelog";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ c31io ];
    mainProgram = "chatbox";

    # Help porting to other platforms :)
    platforms = [ "x86_64-linux" ];
  };
}
