{
  lib,
  fetchFromGitLab,
  callPackage,
}:

let
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "coolercontrol";
    repo = "coolercontrol";
    rev = version;
    hash = "sha256-jsgso9MHt5Szzp9YkuXz8qysdN0li/zD2R/vSZ2Lw5M=";
  };

  meta = with lib; {
    description = "Monitor and control your cooling devices";
    homepage = "https://gitlab.com/coolercontrol/coolercontrol";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [
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
