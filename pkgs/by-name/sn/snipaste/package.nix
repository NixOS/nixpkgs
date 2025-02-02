{
  appimageTools,
  lib,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "snipaste";
  version = "2.9-Beta2";

  src = fetchurl {
    url = "https://download.snipaste.com/archives/Snipaste-${version}-x86_64.AppImage";
    hash = "sha256-VJvw3M1Ohfji/PoIxn4gc9KcFl6H1wRYW5Pbf1p5rlg=";
  };

  meta = with lib; {
    description = "Screenshot tools";
    homepage = "https://www.snipaste.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ luftmensch-luftmensch ];
    mainProgram = "snipaste";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}
