{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.1.1";
  kde-channel = "stable";
  sha256 = "sha256-Tdv4l6+nsYcTFpfRKiO6OYlGOAaLLq4Ss7Q0/kKtjiQ=";
})
