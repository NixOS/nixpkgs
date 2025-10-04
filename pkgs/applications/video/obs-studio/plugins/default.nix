{
  callPackage,
  qt6Packages,
  pkgsi686Linux,
}:

# When adding new plugins:
# - Respect alphabetical order. On diversion, file a PR.
# - Plugin name should reflect upstream's name. Including or excluding "obs" prefix/suffix.
# - Add plugin to it's own directory (because of future patches).

{
  advanced-scene-switcher = qt6Packages.callPackage ./advanced-scene-switcher { };

  droidcam-obs = callPackage ./droidcam-obs { };

  distroav = qt6Packages.callPackage ./distroav { };

  input-overlay = qt6Packages.callPackage ./input-overlay.nix { };

  looking-glass-obs = callPackage ./looking-glass-obs.nix { };

  obs-3d-effect = callPackage ./obs-3d-effect.nix { };

  obs-advanced-masks = callPackage ./obs-advanced-masks.nix { };

  obs-aitum-multistream = qt6Packages.callPackage ./obs-aitum-multistream.nix { };

  obs-backgroundremoval = callPackage ./obs-backgroundremoval { };

  obs-browser-transition = callPackage ./obs-browser-transition.nix { };

  obs-color-monitor = qt6Packages.callPackage ./obs-color-monitor.nix { };

  obs-command-source = callPackage ./obs-command-source.nix { };

  obs-composite-blur = callPackage ./obs-composite-blur.nix { };

  obs-dir-watch-media = callPackage ./obs-dir-watch-media.nix { };

  obs-dvd-screensaver = callPackage ./obs-dvd-screensaver.nix { };

  obs-freeze-filter = qt6Packages.callPackage ./obs-freeze-filter.nix { };

  obs-gradient-source = callPackage ./obs-gradient-source.nix { };

  obs-gstreamer = callPackage ./obs-gstreamer.nix { };

  obs-hyperion = qt6Packages.callPackage ./obs-hyperion/default.nix { };

  obs-livesplit-one = callPackage ./obs-livesplit-one { };

  obs-markdown = callPackage ./obs-markdown.nix { };

  obs-media-controls = qt6Packages.callPackage ./obs-media-controls.nix { };

  obs-move-transition = callPackage ./obs-move-transition.nix { };

  obs-multi-rtmp = qt6Packages.callPackage ./obs-multi-rtmp { };

  obs-mute-filter = callPackage ./obs-mute-filter.nix { };

  obs-noise = callPackage ./obs-noise.nix { };

  obs-pipewire-audio-capture = callPackage ./obs-pipewire-audio-capture.nix { };

  obs-recursion-effect = callPackage ./obs-recursion-effect.nix { };

  obs-replay-source = qt6Packages.callPackage ./obs-replay-source.nix { };

  obs-retro-effects = callPackage ./obs-retro-effects.nix { };

  obs-rgb-levels = callPackage ./obs-rgb-levels.nix { };

  obs-scale-to-sound = callPackage ./obs-scale-to-sound.nix { };

  obs-scene-as-transition = callPackage ./obs-scene-as-transition.nix { };

  obs-shaderfilter = qt6Packages.callPackage ./obs-shaderfilter.nix { };

  obs-source-clone = callPackage ./obs-source-clone.nix { };

  obs-source-record = callPackage ./obs-source-record.nix { };

  obs-source-switcher = callPackage ./obs-source-switcher.nix { };

  obs-stroke-glow-shadow = callPackage ./obs-stroke-glow-shadow.nix { };

  obs-teleport = callPackage ./obs-teleport { };

  obs-text-pthread = callPackage ./obs-text-pthread.nix { };

  obs-transition-table = qt6Packages.callPackage ./obs-transition-table.nix { };

  obs-tuna = qt6Packages.callPackage ./obs-tuna { };

  obs-vaapi = callPackage ./obs-vaapi { };

  obs-vertical-canvas = qt6Packages.callPackage ./obs-vertical-canvas.nix { };

  obs-vintage-filter = callPackage ./obs-vintage-filter.nix { };

  obs-vkcapture = callPackage ./obs-vkcapture.nix {
    obs-vkcapture32 = pkgsi686Linux.obs-studio-plugins.obs-vkcapture;
  };

  obs-vnc = callPackage ./obs-vnc.nix { };

  obs-websocket = qt6Packages.callPackage ./obs-websocket.nix { }; # Websocket 4.x compatibility for OBS Studio 28+

  pixel-art = callPackage ./pixel-art.nix { };

  wlrobs = callPackage ./wlrobs.nix { };

  waveform = callPackage ./waveform { };
}
