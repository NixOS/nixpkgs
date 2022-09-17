{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "22.8.2";
  sha256 = "114lfq5d5b09zg14iwnmaf0vmm183xr37q7b4bj3m8zbzhpbk7xx";
  vendorSha256 = "sha256-hKdokt5QW50oc2z8UFMq78DRWpwPlL5tSf2F0rQNEQ8=";
}
