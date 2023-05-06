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

  obs-backgroundremoval = callPackage ./obs-backgroundremoval { };

  obs-gstreamer = callPackage ./obs-gstreamer.nix { };

  obs-hyperion = qt6Packages.callPackage ./obs-hyperion/default.nix { };

  obs-livesplit-one = callPackage ./obs-livesplit-one { };

  obs-move-transition = callPackage ./obs-move-transition.nix { };

  obs-multi-rtmp = qt6Packages.callPackage ./obs-multi-rtmp { };

  obs-ndi = qt6Packages.callPackage ./obs-ndi { };

  obs-nvfbc = callPackage ./obs-nvfbc.nix { };

  obs-pipewire-audio-capture = callPackage ./obs-pipewire-audio-capture.nix { };

  obs-source-clone = callPackage ./obs-source-clone.nix { };

  obs-source-record = callPackage ./obs-source-record.nix { };

  obs-teleport = callPackage ./obs-teleport { };

  obs-vaapi = callPackage ./obs-vaapi { };

  obs-vkcapture = callPackage ./obs-vkcapture.nix {
    obs-vkcapture32 = pkgsi686Linux.obs-studio-plugins.obs-vkcapture;
  };

  obs-websocket = throw "obs-websocket has been removed: Functionality has been integrated into obs-studio itself.";

  wlrobs = callPackage ./wlrobs.nix { };
}
