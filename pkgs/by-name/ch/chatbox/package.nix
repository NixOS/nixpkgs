{
  lib,
  appimageTools,
  fetchurl,
  writeScript,
}:
let
  pname = "chatbox";
  version = "1.16.3";

  src = fetchurl {
    url = "https://download.chatboxai.app/releases/Chatbox-${version}-x86_64.AppImage";
    hash = "sha256-Vits1RCDAsaTglbFo1y2YeiNBGou9m6BScV+rMGp3Rw=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/xyz.chatboxapp.app.desktop $out/share/applications/chatbox.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/xyz.chatboxapp.app.png $out/share/icons/hicolor/512x512/apps/chatbox.png
    substituteInPlace $out/share/applications/chatbox.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=chatbox' \
      --replace-fail 'Icon=xyz.chatboxapp.app' 'Icon=chatbox'
  '';

  passthru.updateScript = writeScript "update-chatbox" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl gnugrep common-updater-scripts
    version=$(curl -I -X GET https://chatboxai.app/install_chatbox/linux | grep -oP 'Chatbox-\K[0-9]+\.[0-9]+\.[0-9]+')
    update-source-version chatbox $version
  '';

  meta = {
    description = "AI client application and smart assistant";
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
