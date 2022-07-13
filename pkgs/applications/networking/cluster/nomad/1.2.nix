{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.2.9";
  sha256 = "05pd4y5aq91ac73447aqr0pk56rx5qhqzzp5cw4w06yh5iry0bmn";
  vendorSha256 = "08nqqd3dz8bzxnh729kckvg59wnvmixmsh8g74nlxk90gq07zsn4";
}
