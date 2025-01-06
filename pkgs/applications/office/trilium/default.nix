{ lib, callPackage, ... }:

let
  metaCommon = with lib; {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/zadam/trilium";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      fliegendewurst
      eliandoran
    ];
  };
in
{

  trilium-desktop = callPackage ./desktop.nix { metaCommon = metaCommon; };
  trilium-server = callPackage ./server.nix { metaCommon = metaCommon; };

}
