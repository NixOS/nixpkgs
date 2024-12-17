{
  fetchurl,
  appimageTools,
  lib,
  stdenv,
}:
let
  pname = "navicat-premium";
  version = "17.1.7";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://web.archive.org/web/20241217004300/https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
        hash = "sha256-5dzZh06Ld8t4tgE3tWGPAaBuKcT9iSxi8KpSdO4Un64=";
      };
      aarch64-linux = fetchurl {
        url = "https://web.archive.org/web/20241217005701/https://dn.navicat.com/download/navicat17-premium-en-aarch64.AppImage";
        hash = "sha256-4NvjdNTo/WUlZIRAzA2D39NupqMjlCvjHSWk06spqRc=";
      };
    }
    .${stdenv.hostPlatform.system};

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
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "navicat-premium";
  };
}
