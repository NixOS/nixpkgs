let
  rev = "cmpkgs-latest";
  nixpkgs = /root/code/nixpkgs;
  mkAzureImage = (import "${nixpkgs}/nixos/modules/virtualisation/azure-mkimage.nix").mkAzureImage;
in mkAzureImage {
  inherit nixpkgs rev;
  configFile = ./azure-config-user-custom.nix;
  diskSize = 2048;
}
