{ callPackage, libsForQt5 }:

{
  obs-gstreamer = callPackage ./obs-gstreamer.nix {};
  obs-move-transition = callPackage ./obs-move-transition.nix {};
  obs-multi-rtmp = libsForQt5.callPackage ./obs-multi-rtmp.nix {};
}
