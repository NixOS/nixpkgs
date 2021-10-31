{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.0.0-beta2";
  kde-channel = "unstable";
  sha256 = "0hwh6k40f4kmwg14dy0vvm0m8cx8n0q67lrrc620da9mign3hjs7";
})
