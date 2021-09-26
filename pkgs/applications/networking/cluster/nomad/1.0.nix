{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.11";
  sha256 = "15h7w020p576zl91s5mr4npcmngrqqfj9xzlx6bk9i1cp6h4w0jy";
}
