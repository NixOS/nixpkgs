{
  lib,
  fetchFromGitLab,
  callPackage,
}:

let
  version = "4.1.0";

  src = fetchFromGitLab {
    owner = "coolercontrol";
    repo = "coolercontrol";
    tag = version;
    hash = "sha256-v1enPMezagA3gcYD5EbC1ecTOXEsMLRGWIKzgDxzRWg=";
  };

  meta = {
    description = "Monitor and control your cooling devices";
    homepage = "https://gitlab.com/coolercontrol/coolercontrol";
    license = lib.licenses.gpl3Plus;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      codifryed
      OPNA2608
    ];
  };

  applySharedDetails = drv: drv { inherit version src meta; };
in
{
  coolercontrol-ui-data = applySharedDetails (callPackage ./coolercontrol-ui-data.nix { });

  coolercontrold = applySharedDetails (callPackage ./coolercontrold.nix { });

  coolercontrol-gui = applySharedDetails (callPackage ./coolercontrol-gui.nix { });
}
