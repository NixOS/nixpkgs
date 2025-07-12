{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:
let
  pname = "navicat-premium";
  version = "17.2.5";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://web.archive.org/web/20250708035214/https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
        hash = "sha256-Zqf7bSXzmp+S6TotS8gDboFlI3JrOrNMP9ZcM6E2TyE=";
      };
      aarch64-linux = fetchurl {
        url = "https://web.archive.org/web/20250708044713/https://dn.navicat.com/download/navicat17-premium-en-aarch64.AppImage";
        hash = "sha256-10ra8WMIsH8x8QibUaq+tqp4VO2t5OL0KhwmW9v9SXw=";
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
