{ callPackage, libsForQt5 }:

{
  obs-gstreamer = callPackage ./obs-gstreamer.nix {};
  obs-move-transition = callPackage ./obs-move-transition.nix {};
  obs-multi-rtmp = libsForQt5.callPackage ./obs-multi-rtmp.nix {};
  obs-ndi = libsForQt5.callPackage ./obs-ndi.nix {};
  obs-websocket = libsForQt5.callPackage ./obs-websocket.nix {};
  wlrobs = callPackage ./wlrobs.nix {};
  looking-glass-obs = callPackage ./looking-glass-obs.nix {};
  obs-nvfbc = callPackage ./obs-nvfbc.nix {};
  obs-pipewire-audio-capture = callPackage ./obs-pipewire-audio-capture.nix {};
  obs-vkcapture = callPackage ./obs-vkcapture.nix {};
  obs-backgroundremoval = callPackage ./obs-backgroundremoval.nix {};
}
