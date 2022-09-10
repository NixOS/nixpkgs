{ callPackage, libsForQt5, pkgsi686Linux }:

# When adding new plugins:
# - Respect alphabetical order. On diversion, file a PR.
# - Plugin name should reflect upstream's name. Including or excluding "obs" prefix/suffix.
# - Add plugin to it's own directory (because of future patches).

{
  looking-glass-obs = callPackage ./looking-glass-obs.nix { };

  obs-backgroundremoval = callPackage ./obs-backgroundremoval.nix { };

  obs-gstreamer = callPackage ./obs-gstreamer.nix { };

  obs-hyperion = libsForQt5.callPackage ./obs-hyperion/default.nix { };

  obs-move-transition = callPackage ./obs-move-transition.nix { };

  obs-multi-rtmp = libsForQt5.callPackage ./obs-multi-rtmp.nix { };

  obs-ndi = libsForQt5.callPackage ./obs-ndi.nix { };

  obs-nvfbc = callPackage ./obs-nvfbc.nix { };

  obs-pipewire-audio-capture = callPackage ./obs-pipewire-audio-capture.nix { };

  obs-vkcapture = callPackage ./obs-vkcapture.nix {
    obs-vkcapture32 = pkgsi686Linux.obs-studio-plugins.obs-vkcapture;
  };

  obs-websocket = libsForQt5.callPackage ./obs-websocket.nix { };

  wlrobs = callPackage ./wlrobs.nix { };
}
