{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.0.6";
  kde-channel = "stable";
  sha256 = "sha256:0qhf7vm13v33yk67n7wdcgrqpk7yvajdlkqcp7zhrl2z7qdnvmzd";
})
