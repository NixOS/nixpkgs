{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:
let
  pname = "navicat-premium";
  version = "17.3.1";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://web.archive.org/web/20250904095427/https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
        hash = "sha256-5vGctpbAg3mVhalr+Yg3iFZNCyY+0+a98sldhUcHkm0=";
      };
      aarch64-linux = fetchurl {
        url = "https://web.archive.org/web/20250904095643/https://dn.navicat.com/download/navicat17-premium-en-aarch64.AppImage";
        hash = "sha256-r31u/b/3HO9PEQtIr9AZ/5NVrRcgJ+GACHPWCICZYec=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

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
    changelog = "https://www.navicat.com/products/navicat-premium-release-note";
    description = "Database development tool that allows you to simultaneously connect to many databases";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "navicat-premium";
  };
}
