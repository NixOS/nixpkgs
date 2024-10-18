{ lib, callPackage, ... }:

let
  metaCommon = with lib; {
    description = "Hierarchical note taking application with focus on building large personal knowledge bases";
    homepage = "https://github.com/TriliumNext/Notes";
    license = licenses.agpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ eliandoran ];
  };
  version = "0.90.4";
in
{

  trilium-next-desktop = callPackage ./desktop.nix {
    metaCommon = metaCommon;
    version = version;
  };
  trilium-next-server = callPackage ./server.nix {
    metaCommon = metaCommon;
    version = version;
  };

}
