{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./genericModule.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.2.2";
  sha256 = "sha256-hFoyI1Py85XYcqyDAY+txQlQf2MXTSnHRWazqg9V3eE";
  vendorSha256 = "sha256-vR3v/8IVNCMIYDudqXletmkYcHj9w8VNMYs8T1AQUDY";
}
