{ callPackage, qt6Packages, pkgsi686Linux }:

# When adding new plugins:
# - Respect alphabetical order. On diversion, file a PR.
# - Plugin name should reflect upstream's name. Including or excluding "obs" prefix/suffix.
# - Add plugin to it's own directory (because of future patches).

{
  advanced-scene-switcher = qt6Packages.callPackage ./advanced-scene-switcher { };

  droidcam-obs = callPackage ./droidcam-obs { };

  input-overlay = qt6Packages.callPackage ./input-overlay.nix { };

  looking-glass-obs = callPackage ./looking-glass-obs.nix { };

  obs-3d-effect = callPackage ./obs-3d-effect.nix { };

  obs-backgroundremoval = callPackage ./obs-backgroundremoval { };

  obs-command-source = callPackage ./obs-command-source.nix { };

  obs-gradient-source = callPackage ./obs-gradient-source.nix { };

  obs-gstreamer = callPackage ./obs-gstreamer.nix { };

  obs-hyperion = qt6Packages.callPackage ./obs-hyperion/default.nix { };

  obs-livesplit-one = callPackage ./obs-livesplit-one { };

  obs-move-transition = callPackage ./obs-move-transition.nix { };

  obs-multi-rtmp = qt6Packages.callPackage ./obs-multi-rtmp { };

  obs-mute-filter = callPackage ./obs-mute-filter.nix { };

  obs-ndi = qt6Packages.callPackage ./obs-ndi { };

  obs-nvfbc = callPackage ./obs-nvfbc.nix { };

  obs-pipewire-audio-capture = callPackage ./obs-pipewire-audio-capture.nix { };

  obs-rgb-levels-filter = callPackage ./obs-rgb-levels-filter.nix { };

  obs-scale-to-sound = callPackage ./obs-scale-to-sound.nix { };

  obs-shaderfilter = qt6Packages.callPackage ./obs-shaderfilter.nix { };

  obs-source-clone = callPackage ./obs-source-clone.nix { };

  obs-source-record = callPackage ./obs-source-record.nix { };

  obs-source-switcher = callPackage ./obs-source-switcher.nix { };

  obs-teleport = callPackage ./obs-teleport { };

  obs-text-pthread = callPackage ./obs-text-pthread.nix { };

  obs-transition-table = qt6Packages.callPackage ./obs-transition-table.nix { };

  obs-vaapi = callPackage ./obs-vaapi { };

  obs-vertical-canvas = qt6Packages.callPackage ./obs-vertical-canvas.nix { };

  obs-vintage-filter = callPackage ./obs-vintage-filter.nix { };

  obs-vkcapture = callPackage ./obs-vkcapture.nix {
    obs-vkcapture32 = pkgsi686Linux.obs-studio-plugins.obs-vkcapture;
  };

  obs-websocket = qt6Packages.callPackage ./obs-websocket.nix { }; # Websocket 4.x compatibility for OBS Studio 28+

  wlrobs = callPackage ./wlrobs.nix { };
}
