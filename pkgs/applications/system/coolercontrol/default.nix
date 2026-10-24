{
  lib,
  fetchFromGitLab,
  callPackage,
}:

let
  version = "5.1.1";

  src = fetchFromGitLab {
    owner = "coolercontrol";
    repo = "coolercontrol";
    tag = version;
    hash = "sha256-XlMlu39tboZN/9qVIORv5yobbHXkxNzyNqxQl0wc8Ro=";
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
