{
  ath11k-firmware,
}:

ath11k-firmware.mkAthFirmware {
  athVersion = "ath12k";
  rev = "aea9e010506e1960dee1ab2fb87e55390c485cc6";
  hash = "sha256-2+QM2BH7XupXXMwrJg0whwHYC3WC8Km6zt3iewmBq3Q=";
  updateFilename = ./package.nix;
  position = "pkgs/by-name/at/ath12k-firmware:10";
}
