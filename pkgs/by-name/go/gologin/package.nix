{
  appimageTools,
  lib,
  fetchzip,
}:
let
  pname = "gologin";
  version = "4.0.2";

  srcTar = fetchzip {
    url = "https://dl.gologin.com/gologin.tar";
    hash = "sha256-y6DpgW9+Zhoh3M3NB39xijEaqfZxUDQ8fWUmw61owDI=";
  };
in
appimageTools.wrapType2 {
  inherit pname version;

  src = "${srcTar}/GoLogin-${version}";

  meta = {
    description = "Anti-detect browser for managing multiple accounts on a single device.";
    homepage = "https://gologin.com/";
    mainProgram = "gologin";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ felipe-9 ];
    platforms = lib.platforms.linux;
  };
}
