{
  appimageTools,
  lib,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "snipaste";
  version = "2.10.2";

  src = fetchurl {
    url = "https://download.snipaste.com/archives/Snipaste-${version}-x86_64.AppImage";
    hash = "sha256-u9e2d9ZpHDbDIsFkseOdJX2Kspn9TkhFfZxbeielDA8=";
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Screenshot tools";
    homepage = "https://www.snipaste.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      ltrump
    ];
    mainProgram = "snipaste";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
