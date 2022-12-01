{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.2.15";
  sha256 = "sha256-p9yRjSapQAhuHv+slUmYI25bUb1N1A7LBiJOdk1++iI=";
  vendorSha256 = "sha256-6d3tE337zVAIkzQzAnV2Ya5xwwhuzmKgtPUJcJ9HRto=";
}
