{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:
let
  pname = "navicat-premium";
  version = "17.2.3";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://web.archive.org/web/20250516003452/https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
        hash = "sha256-QGz+0D0rNkuzkLxLO/tFlif4X4Zuzpb+btkqKNOBi7c=";
      };
      aarch64-linux = fetchurl {
        url = "https://web.archive.org/web/20250516004158/https://dn.navicat.com/download/navicat17-premium-en-aarch64.AppImage";
        hash = "sha256-hxaqK9dPm/0mL3+LoQFeVSe14AD+tfYSNvEC9JsUvRE=";
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
