{
  lib,
  fetchFromGitLab,
  callPackage,
}:

let
  version = "1.4.4";

  src = fetchFromGitLab {
    owner = "coolercontrol";
    repo = "coolercontrol";
    rev = version;
    hash = "sha256-9l10X4uDv3KJz582QQMhqh38bwDtQVHm9HdAVNC6Kfg=";
  };

  meta = {
    description = "Monitor and control your cooling devices";
    homepage = "https://gitlab.com/coolercontrol/coolercontrol";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      codifryed
      OPNA2608
    ];
  };

  applySharedDetails = drv: drv { inherit version src meta; };
in
rec {
  coolercontrol-ui-data = applySharedDetails (callPackage ./coolercontrol-ui-data.nix { });

  coolercontrold = applySharedDetails (callPackage ./coolercontrold.nix { });

  coolercontrol-gui = applySharedDetails (callPackage ./coolercontrol-gui.nix { });

  coolercontrol-liqctld = applySharedDetails (callPackage ./coolercontrol-liqctld.nix { });
}
