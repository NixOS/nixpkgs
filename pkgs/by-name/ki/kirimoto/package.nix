{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "4.6.3";
  pname = "kirimoto";

  src = fetchurl {
    url = "https://github.com/GridSpace/grid-apps/releases/download/${version}/KiriMoto-linux-x86_64.AppImage";
    hash = "sha256-YCfDCR92xtwL3634iIMYf6IjkeqoWrF7/YNCwKSjnfs==";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/grid-apps.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/grid-apps.png -t $out/share/icons/hicolor/512x512/apps/

    substituteInPlace $out/share/applications/grid-apps.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram} --no-sandbox --ozone-platform=x11 --disable-gpu-sandbox --in-process-gpu'
  '';

  meta = {
    description = "Open source Slicer for CAM, Laser and 3D-printer";
    homepage = "https://grid.space/";
    downloadPage = "https://grid.space/downloads.html";
    changelog = "https://grid.space/news";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ FlorisMenninga ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "kirimoto";
  };
}
