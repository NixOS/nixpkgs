{ lib, appimageTools, fetchurl }:

let
  version = "1.7.7";
  pname = "lunatask";

  src = fetchurl {
    url = "https://lunatask.app/download/Lunatask-${version}.AppImage";
    sha256 = "sha256-3WiJR+gwudeLs6Mn75SJP4BZ6utwxvvRLOHe/W+1Pfs=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
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
