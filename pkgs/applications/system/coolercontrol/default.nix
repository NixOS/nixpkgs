{
  lib,
  fetchFromGitLab,
  callPackage,
}:

let
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "coolercontrol";
    repo = "coolercontrol";
    tag = version;
    hash = "sha256-sB6afsprHNS82eoNtViJgFo/+I2kQwucGY6pV3M/roQ=";
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
