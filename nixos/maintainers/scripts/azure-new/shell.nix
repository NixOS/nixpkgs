with (import ../../../../default.nix {});
stdenv.mkDerivation {
  name = "nixcfg-azure-devenv";

  nativeBuildInputs = [
    azure-cli
    bash
    cacert
    azure-storage-azcopy
  ];

  AZURE_CONFIG_DIR="/tmp/azure-cli/.azure";
}
