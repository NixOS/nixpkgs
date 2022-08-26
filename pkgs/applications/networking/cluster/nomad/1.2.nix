{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.2.11";
  sha256 = "sha256-mBaqTiPCPNjhdBKv4ydlNuJxGwFCcJTj4khaOJs9LQM=";
  vendorSha256 = "sha256-2Draoydjsu15GK1QMHiZCB9ldTrAb0FwhO7MUH3s1Q8=";
}
