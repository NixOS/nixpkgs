{ lib
, appimageTools
, fetchurl
, gitUpdater
}:

let
  pname = "simplex-chat-desktop";
  version = "5.5.5";

  src = fetchurl {
    url = "https://github.com/simplex-chat/simplex-chat/releases/download/v${version}/simplex-desktop-x86_64.AppImage";
    hash = "sha256-MD1AbpHlpaMaPlpJmGp0oPbOYPmJEhhIXmexkpCr1wY=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: with pkgs; [
      makeWrapper
    ];

    extraBwrapArgs = [
      "--setenv _JAVA_AWT_WM_NONREPARENTING 1"
    ];

    extraInstallCommands = ''
      install --mode=444 -D ${appimageContents}/chat.simplex.app.desktop --target-directory=$out/share/applications
      substituteInPlace $out/share/applications/chat.simplex.app.desktop \
        --replace 'Exec=simplex' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "Desktop application for SimpleX Chat";
    mainProgram = "simplex-chat-desktop";
    homepage = "https://simplex.chat";
    changelog = "https://github.com/simplex-chat/simplex-chat/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ yuu ];
    platforms = [ "x86_64-linux" ];
  };

  passthru.updateScript = gitUpdater {
    url = "https://github.com/simplex-chat/simplex-chat";
    rev-prefix = "v";
    # skip tags that does not correspond to official releases, like vX.Y.Z-(beta,fdroid,armv7a).
    ignoredVersions = "-";
  };
}
