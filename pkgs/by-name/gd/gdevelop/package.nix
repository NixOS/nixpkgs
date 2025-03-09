{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:
let
  version = "5.5.224";
  pname = "gdevelop";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "https://github.com/4ian/GDevelop/releases/download/v${version}/GDevelop-5-${version}.AppImage";
        sha256 = "sha256-/o7Yyu5BjRfpg4Tl0ZwN6/KD9Kg4LcEmUqlO7NE/dew=";
      }
    else
      throw "${pname}-${version} is not supported on ${stdenv.hostPlatform.system}";

  appimageContents = appimageTools.extractType2 { inherit pname src; };

  dontPatchELF = true;

in
appimageTools.wrapType2 rec {
  inherit pname version src;

  meta = {
    description = "Graphical Game Development Studio";
    homepage = "https://gdevelop.io/";
    downloadPage = "https://github.com/4ian/GDevelop/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ tombert ];
    platforms = [ "x86_64-linux" ];
  };

}
