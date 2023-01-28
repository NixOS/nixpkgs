{ callPackage, qt6Packages, pkgsi686Linux }:

# When adding new plugins:
# - Respect alphabetical order. On diversion, file a PR.
# - Plugin name should reflect upstream's name. Including or excluding "obs" prefix/suffix.
# - Add plugin to it's own directory (because of future patches).

{
  droidcam-obs = callPackage ./droidcam-obs { };

  input-overlay = qt6Packages.callPackage ./input-overlay.nix { };

  looking-glass-obs = callPackage ./looking-glass-obs.nix { };

  obs-gstreamer = callPackage ./obs-gstreamer.nix { };

  obs-hyperion = qt6Packages.callPackage ./obs-hyperion/default.nix { };

  obs-move-transition = callPackage ./obs-move-transition.nix { };

  obs-multi-rtmp = qt6Packages.callPackage ./obs-multi-rtmp { };

  obs-ndi = qt6Packages.callPackage ./obs-ndi.nix { };

  obs-nvfbc = callPackage ./obs-nvfbc.nix { };

  obs-pipewire-audio-capture = callPackage ./obs-pipewire-audio-capture.nix { };

  obs-source-record = callPackage ./obs-source-record.nix { };

  obs-vkcapture = callPackage ./obs-vkcapture.nix {
    obs-vkcapture32 = pkgsi686Linux.obs-studio-plugins.obs-vkcapture;
  };

  obs-websocket = throw "obs-websocket has been removed: Functionality has been integrated into obs-studio itself.";

  obs-backgroundremoval = throw "obs-backgroundremoval has been removed: It does not work anymore and is unmaintained.";

  wlrobs = callPackage ./wlrobs.nix { };
}
