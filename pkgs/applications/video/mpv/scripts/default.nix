{ lib
, callPackage
, config
, runCommand
}:

let
  buildLua = callPackage ./buildLua.nix { };

  addTests = name: drv: drv.override { passthru.tests = lib.attrsets.unionOfDisjoint (drv.passthru.tests or {}) {
    scriptName-is-valid = let
      inherit (drv) scriptName;
      scriptPath = "${drv}/share/mpv/scripts/${scriptName}";
    in runCommand "mpvScripts.${name}.passthru.tests.scriptName-is-valid" {
      meta.maintainers = with lib.maintainers; [ nicoo ];
      preferLocalBuild = true;
    } ''
      if [ -e "${scriptPath}" ]; then
        touch $out
      else
        echo "mpvScripts.\"${name}\" does not contain a script named \"${scriptName}\"" >&2
        exit 1
      fi
    '';
  }; };
in

lib.recurseIntoAttrs
  (lib.mapAttrs addTests ({
    acompressor = callPackage ./acompressor.nix { inherit buildLua; };
    autocrop = callPackage ./autocrop.nix { };
    autodeint = callPackage ./autodeint.nix { };
    autoload = callPackage ./autoload.nix { };
    chapterskip = callPackage ./chapterskip.nix { inherit buildLua; };
    convert = callPackage ./convert.nix { inherit buildLua; };
    cutter = callPackage ./cutter.nix { inherit buildLua; };
    inhibit-gnome = callPackage ./inhibit-gnome.nix { };
    mpris = callPackage ./mpris.nix { };
    mpv-playlistmanager = callPackage ./mpv-playlistmanager.nix { inherit buildLua; };
    mpv-webm = callPackage ./mpv-webm.nix { inherit buildLua; };
    mpvacious = callPackage ./mpvacious.nix { inherit buildLua; };
    quality-menu = callPackage ./quality-menu.nix { inherit buildLua; };
    simple-mpv-webui = callPackage ./simple-mpv-webui.nix { inherit buildLua; };
    sponsorblock = callPackage ./sponsorblock.nix { };
    sponsorblock-minimal = callPackage ./sponsorblock-minimal.nix { inherit buildLua; };
    thumbfast = callPackage ./thumbfast.nix { inherit buildLua; };
    thumbnail = callPackage ./thumbnail.nix { inherit buildLua; };
    uosc = callPackage ./uosc.nix { inherit buildLua; };
    visualizer = callPackage ./visualizer.nix { inherit buildLua; };
    vr-reversal = callPackage ./vr-reversal.nix { };
    webtorrent-mpv-hook = callPackage ./webtorrent-mpv-hook.nix { };
  }
  // (callPackage ./occivink.nix { inherit buildLua; })))
  // lib.optionalAttrs config.allowAliases {
  youtube-quality = throw "'youtube-quality' is no longer maintained, use 'quality-menu' instead"; # added 2023-07-14
}
