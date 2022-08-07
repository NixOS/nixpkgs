{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.0.8";
  kde-channel = "stable";
  sha256 = "sha256:7R0fpQc+4MQVDh/enhCTgpgOqU0y5YRShrv/ILa/XkU=";
})
