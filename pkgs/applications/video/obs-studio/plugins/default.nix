{ callPackage }:

{
  obs-gstreamer = callPackage ./obs-gstreamer.nix {};
  obs-move-transition = callPackage ./obs-move-transition.nix {};
}
