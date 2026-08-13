{
  pkgs ? import ../../../../default.nix { },
}:

pkgs.stdenv.mkDerivation {
  name = "nixcfg-azure-devenv";

  nativeBuildInputs = with pkgs; [
    azure-cli
    bash
    cacert
    azure-storage-azcopy
  ];

  AZURE_CONFIG_DIR = "/tmp/azure-cli/.azure";
}
