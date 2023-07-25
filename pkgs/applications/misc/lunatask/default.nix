{ lib, appimageTools, fetchurl }:

let
  version = "1.6.4";
  pname = "lunatask";

  src = fetchurl {
    url = "https://lunatask.app/download/Lunatask-${version}.AppImage";
    sha256 = "sha256-rvjjzVgtDNryj7GO+ZfK92nZvWRnRPFoy9hEIGjviqQ=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/lunatask.desktop $out/share/applications/lunatask.desktop
    install -m 444 -D ${appimageContents}/lunatask.png $out/share/icons/hicolor/0x0/apps/lunatask.png
    substituteInPlace $out/share/applications/lunatask.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "An all-in-one encrypted todo list, notebook, habit and mood tracker, pomodoro timer, and journaling app";
    longDescription = ''
      Lunatask is an all-in-one encrypted todo list, notebook, habit and mood tracker, pomodoro timer, and journaling app. It remembers stuff for you and keeps track of your mental health.
    '';
    homepage = "https://lunatask.app";
    downloadPage = "https://lunatask.app/download";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ henkery ];
    platforms = [ "x86_64-linux" ];
  };
}
