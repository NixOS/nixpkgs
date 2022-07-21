{ callPackage, libsForQt5 }:

# Normalization: Remove 'obs' from plugin name (since all are 'obs' plugins)

rec {
  gstreamer = callPackage ./gstreamer {};
    obs-gstreamer = gstreamer; # Alias added 2022-07-21

  looking-glass = callPackage ./looking-glass {};
    looking-glass-obs = looking-glass; # Alias added 2022-07-21

  move-transition = callPackage ./move-transition {};
    obs-move-transition = move-transition; # Alias added 2022-07-21

  multi-rtmp = libsForQt5.callPackage ./multi-rtmp {};
    obs-multi-rtmp = multi-rtmp; # Alias added 2022-07-21

  ndi = libsForQt5.callPackage ./ndi {};
    obs-ndi = ndi; # Alias added 2022-07-21

  obs-websocket = libsForQt5.callPackage ./obs-websocket.nix {};
  wlrobs = callPackage ./wlrobs.nix {};
  obs-nvfbc = callPackage ./obs-nvfbc.nix {};
  obs-pipewire-audio-capture = callPackage ./obs-pipewire-audio-capture.nix {};
  obs-vkcapture = callPackage ./obs-vkcapture.nix {};
}
