{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.2.13";
  sha256 = "sha256-yDcvN6cKG1BlBq1ygYB58bS1YRHWqJgLXRlqI7lrW1A=";
  vendorSha256 = "sha256-dPErDlJ4oNpER3Ij4yrN77V8sZvDUuXY7dM39u9xT4I=";
}
