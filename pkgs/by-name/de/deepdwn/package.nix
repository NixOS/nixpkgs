{
  lib,
  requireFile,
  appimageTools,
}:

let
  pname = "deepdwn";
  version = source.version;

  source = lib.importJSON ./source.json;

  src = requireFile {
    name = "Deepdwn-${version}.AppImage";
    hash = source.hash;
    url = "https://www.deepdwn.com/";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/deepdwn.desktop $out/share/applications/deepdwn.desktop
    install -m 444 -D ${appimageContents}/deepdwn.png $out/share/icons/hicolor/512x512/apps/deepdwn.png
    substituteInPlace $out/share/applications/deepdwn.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=deepdwn'
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Markdown editor and organizer for Windows, Mac and Linux";
    homepage = "https://www.deepdwn.com/";
    downloadPage = "https://billiam.itch.io/deepdwn";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ymstnt ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "deepdwn";
    platforms = [ "x86_64-linux" ];
  };
}
