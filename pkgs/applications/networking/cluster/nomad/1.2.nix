{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.2.6";
  sha256 = "1ik8v1jznky9y4m85bzxgyba256zqmm5fs6d5xsvp5rzcylcdwgd";
  vendorSha256 = "1mbvpssf7haaxzx6ka9qzixm49jck8i89w8ymkaddgmxhlbxjv05";
}
