{ callPackage, libsForQt5 }:

# Normalization: Remove 'obs' from plugin name (since all are 'obs' plugins)

rec {
  gstreamer = callPackage ./gstreamer {};
    obs-gstreamer = gstreamer; # Alias added 2022-07-21

  obs-move-transition = callPackage ./obs-move-transition.nix {};
  obs-multi-rtmp = libsForQt5.callPackage ./obs-multi-rtmp.nix {};
  obs-ndi = libsForQt5.callPackage ./obs-ndi.nix {};
  obs-websocket = libsForQt5.callPackage ./obs-websocket.nix {};
  wlrobs = callPackage ./wlrobs.nix {};
  looking-glass-obs = callPackage ./looking-glass-obs.nix {};
  obs-nvfbc = callPackage ./obs-nvfbc.nix {};
  obs-pipewire-audio-capture = callPackage ./obs-pipewire-audio-capture.nix {};
  obs-vkcapture = callPackage ./obs-vkcapture.nix {};
}
