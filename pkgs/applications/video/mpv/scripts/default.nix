{ lib
, callPackage
, config
}:

let buildLua = callPackage ./buildLua.nix { };
in lib.recurseIntoAttrs
  ({
    acompressor = callPackage ./acompressor.nix { inherit buildLua; };
    autocrop = callPackage ./autocrop.nix { };
    autodeint = callPackage ./autodeint.nix { };
    autoload = callPackage ./autoload.nix { };
    chapterskip = callPackage ./chapterskip.nix { inherit buildLua; };
    convert = callPackage ./convert.nix { inherit buildLua; };
    inhibit-gnome = callPackage ./inhibit-gnome.nix { };
    mpris = callPackage ./mpris.nix { };
    mpv-playlistmanager = callPackage ./mpv-playlistmanager.nix { inherit buildLua; };
    mpv-webm = callPackage ./mpv-webm.nix { };
    mpvacious = callPackage ./mpvacious.nix { inherit buildLua; };
    quality-menu = callPackage ./quality-menu.nix { inherit buildLua; };
    simple-mpv-webui = callPackage ./simple-mpv-webui.nix { };
    sponsorblock = callPackage ./sponsorblock.nix { };
    thumbfast = callPackage ./thumbfast.nix { inherit buildLua; };
    thumbnail = callPackage ./thumbnail.nix { inherit buildLua; };
    uosc = callPackage ./uosc.nix { };
    visualizer = callPackage ./visualizer.nix { };
    vr-reversal = callPackage ./vr-reversal.nix { };
    webtorrent-mpv-hook = callPackage ./webtorrent-mpv-hook.nix { };
    cutter = callPackage ./cutter.nix { };
  }
  // (callPackage ./occivink.nix { inherit buildLua; }))
  // lib.optionalAttrs config.allowAliases {
  youtube-quality = throw "'youtube-quality' is no longer maintained, use 'quality-menu' instead"; # added 2023-07-14
}
