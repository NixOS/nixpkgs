{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "5.0.0";
  kde-channel = "stable";
  sha256 = "sha256-hNWDPbyrP9OkGPTDdnDYKtkZQw8MbQpXuZOQdHHuzFc=";
})
