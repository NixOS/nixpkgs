{
  fetchurl,
  appimageTools,
  lib,
  stdenv,
}:
let
  pname = "navicat-premium";
  version = "17.1.8";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://web.archive.org/web/20250208181645/https://dn.navicat.com/download/navicat17-premium-en-x86_64.AppImage";
        hash = "sha256-dPZIgq0vuBF4K2U12EKdGnDpfS67Afxmw+G7eLyYdpg=";
      };
      aarch64-linux = fetchurl {
        url = "https://web.archive.org/web/20250208182611/https://dn.navicat.com/download/navicat17-premium-en-aarch64.AppImage";
        hash = "sha256-IDcL4uqhTd20UOX3Zt8lpeTj8FhcbT+7RtsEzcP5dGI=";
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
