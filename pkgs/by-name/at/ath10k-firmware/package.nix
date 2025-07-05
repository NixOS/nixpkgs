{
  ath11k-firmware,
}:

ath11k-firmware.mkAthFirmware {
  athVersion = "ath10k";
  rev = "ca0916244fb9ae75242585f3bb8397c5732b910c";
  hash = "sha256-akcdhbRAvGGFs/cje09swpzBRScwhTA7loTsUDi2uC4=";
  updateFilename = ./package.nix;
  position = "pkgs/by-name/at/ath10k-firmware:10";
}
