{ config, pkgs, lib, ... }: {
  # Euclid Linux 3D Budgie+Compiz Branding
  environment.etc."os-release".text = lib.mkForce ''
    NAME="Euclid Linux 3D"
    PRETTY_NAME="Euclid Linux 3D"
    ID=euclid-linux-3d
    VARIANT="Budgie+Compiz"
    VARIANT_ID=budgie-compiz
    HOME_URL="https://euclidprojects.org/linux-3d"
    SUPPORT_URL="https://euclidprojects.org/contact"
    DOCUMENTATION_URL="https://euclidprojects.org/linux-3d"
    LOGO=euclid-linux-3d
    VENDOR="Euclid Projects"
  '';

  isoImage.volumeID = lib.mkForce "EUCLID_LINUX_3D";
  isoImage.isoName = lib.mkForce "euclid-linux-3d-budgie-compiz-x86_64.iso";

  networking.hostName = lib.mkForce "euclid-linux";
}
