{ lib
, callPackage
, config
, runCommand
}:

let
  buildLua = callPackage ./buildLua.nix { };

  unionOfDisjoints = lib.fold lib.attrsets.unionOfDisjoint {};

  addTests = name: drv: let
    inherit (drv) scriptName;
    scriptPath = "share/mpv/scripts/${scriptName}";
    fullScriptPath = "${drv}/${scriptPath}";

  in drv.overrideAttrs (old: { passthru = (old.passthru or {}) // { tests = unionOfDisjoints [
    (old.passthru.tests or {})

    {
      scriptName-is-valid = runCommand "mpvScripts.${name}.passthru.tests.scriptName-is-valid" {
        meta.maintainers = with lib.maintainers; [ nicoo ];
        preferLocalBuild = true;
      } ''
        if [ -e "${fullScriptPath}" ]; then
          touch $out
        else
          echo "mpvScripts.\"${name}\" does not contain a script named \"${scriptName}\"" >&2
          exit 1
        fi
      '';
    }

    # can't check whether `fullScriptPath` is a directory, in pure-evaluation mode
    (with lib; optionalAttrs (! any (s: hasSuffix s drv.passthru.scriptName) [ ".js" ".lua" ".so" ]) {
      single-main-in-script-dir = runCommand "mpvScripts.${name}.passthru.tests.single-main-in-script-dir" {
        meta.maintainers = with lib.maintainers; [ nicoo ];
        preferLocalBuild = true;
      } ''
        die() {
          echo "$@" >&2
          exit 1
        }

        cd "${drv}/${scriptPath}"  # so the glob expands to filenames only
        mains=( main.* )
        if [ "''${#mains[*]}" -eq 1 ]; then
          touch $out
        elif [ "''${#mains[*]}" -eq 0 ]; then
          die "'${scriptPath}' contains no 'main.*' file"
        else
          die "'${scriptPath}' contains multiple 'main.*' files:" "''${mains[*]}"
        fi
      '';
    })
  ]; }; });
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
