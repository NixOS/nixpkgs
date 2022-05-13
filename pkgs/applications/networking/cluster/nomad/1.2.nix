{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.2.7";
  sha256 = "13whyjl0shr00mn46f361ybz90zwkiyab9ygcs0hrs75lgvkmfm9";
  vendorSha256 = "177gv0h8bhxd5j78sf4is86zzq8xl9schg1hbyh0hmwg4whhqm8a";
}
