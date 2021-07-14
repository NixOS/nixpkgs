{ callPackage, libsForQt5 }:

{
  obs-gstreamer = callPackage ./obs-gstreamer.nix {};
  obs-move-transition = callPackage ./obs-move-transition.nix {};
  obs-multi-rtmp = libsForQt5.callPackage ./obs-multi-rtmp.nix {};
  obs-ndi = libsForQt5.callPackage ./obs-ndi.nix {};
  wlrobs = callPackage ./wlrobs.nix {};
  looking-glass-obs = callPackage ./looking-glass-obs.nix {};
}
