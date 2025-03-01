{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "2.0.16";
  pname = "lunatask";

  src = fetchurl {
    url = "https://github.com/lunatask/lunatask/releases/download/v${version}/Lunatask-${version}.AppImage";
    hash = "sha256-W2QeESOPThKgNTWfNWd/N2CHcHZW6fb1KRMu3ZrQGZQ=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D -t $out/share/applications ${appimageContents}/lunatask.desktop
    install -m 444 -D -t $out/share/icons/hicolor/512x512/apps ${appimageContents}/lunatask.png
    substituteInPlace $out/share/applications/lunatask.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=lunatask'
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "All-in-one encrypted todo list, notebook, habit and mood tracker, pomodoro timer, and journaling app";
    longDescription = ''
      Lunatask is an all-in-one encrypted todo list, notebook, habit and mood tracker, pomodoro timer, and journaling app. It remembers stuff for you and keeps track of your mental health.
    '';
    homepage = "https://lunatask.app";
    downloadPage = "https://lunatask.app/download";
    changelog = "https://lunatask.app/releases/${version}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zi3m5f ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lunatask";
  };
}
