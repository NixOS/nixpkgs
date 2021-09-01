{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./genericModule.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.1.4";
  sha256 = "182f3sxw751s8qg16vbssplhl92i9gshgzvflwwvnxraz2795y7l";
  vendorSha256 = "1nddknnsvb05sapbj1c52cv2fmibvdg48f88malxqblzw33wfziq";
}
