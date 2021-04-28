{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.4";
  sha256 = "0znaxz9mzbqb59p6rwa5h89m344m2ci39jsx8dfh1v5fc17r0fcq";
}
