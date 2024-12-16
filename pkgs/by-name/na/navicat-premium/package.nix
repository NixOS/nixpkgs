{
  fetchurl,
  appimageTools,
  lib,
}:
let
  pname = "navicat-premium";
  version = "17.1.6";
  src = fetchurl {
    url = "https://web.archive.org/web/20241127151816/https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
    hash = "sha256-pH5hjHRuN29yBvsBrskCcwgXRUZ95iwEse2O3IiIvGo=";
  };
  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    cp -r ${appimageContents}/usr/share $out/share
    substituteInPlace $out/share/applications/navicat.desktop \
      --replace-fail "Exec=navicat" "Exec=navicat-premium"
  '';

  meta = {
    homepage = "https://www.navicat.com/products/navicat-premium";
    changelog = "https://www.navicat.com/en/products/navicat-premium-release-note";
    description = "Database development tool that allows you to simultaneously connect to many databases";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "navicat-premium";
  };
}
