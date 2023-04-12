{ lib, callPackage, ... }:

let
  metaCommon = with lib; {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/zadam/trilium";
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ fliegendewurst eliandoran ];
  };
in {

  trilium-desktop = callPackage ./desktop.nix { metaCommon = metaCommon; };
  trilium-server = callPackage ./server.nix { metaCommon = metaCommon; };

}
