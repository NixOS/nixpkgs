{
  lib,
  appimageTools,
  fetchurl,
}:

(appimageTools.wrapType2 rec {
  pname = "internxt-drive";
  version = "2.5.3";

  src = fetchurl {
    url = "https://github.com/internxt/drive-desktop-linux/releases/download/v${version}/Internxt-${version}.AppImage";
    hash = "sha256-aUly3nPenLEqwxLwB/7/8V9dQk/FDw84b75FQNWIEQ8=";
  };

  extraPkgs = pkgs: with pkgs; [ fuse2 ];

  meta = with lib; {
    description = "Internxt Drive desktop client for encrypted cloud storage";
    homepage = "https://internxt.com";
    license = licenses.agpl3Only; # aggiorna dopo il curl
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ e1618033 ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
}).overrideAttrs
  (_: {
    strictDeps = true;
    __structuredAttrs = true;
  })
