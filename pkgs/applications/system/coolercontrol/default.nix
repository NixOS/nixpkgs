{
  lib,
  fetchFromGitLab,
  callPackage,
}:

let
  version = "5.1.2";

  src = fetchFromGitLab {
    owner = "coolercontrol";
    repo = "coolercontrol";
    tag = version;
    hash = "sha256-Av0By/DxdBh0n0Og9fho3X8yizpSu2Joe39iM2GyxPg=";
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
    ];
  };

  applySharedDetails = drv: drv { inherit version src meta; };
in
{
  coolercontrol-ui-data = applySharedDetails (callPackage ./coolercontrol-ui-data.nix { });

  coolercontrold = applySharedDetails (callPackage ./coolercontrold.nix { });

  coolercontrol-gui = applySharedDetails (callPackage ./coolercontrol-gui.nix { });
}
