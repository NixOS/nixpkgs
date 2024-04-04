{ lib
, config
, newScope
, runCommand
}:

let
  unionOfDisjoints = lib.fold lib.attrsets.unionOfDisjoint {};

  addTests = name: drv:
    if ! lib.isDerivation drv then
      drv
    else let
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

  scope = self: let
    inherit (self) callPackage;
  in lib.mapAttrs addTests {
    inherit (callPackage ./mpv.nix { })
      acompressor autocrop autodeint autoload;
    inherit (callPackage ./occivink.nix { })
      blacklistExtensions seekTo;

    buildLua = callPackage ./buildLua.nix { };
    chapterskip = callPackage ./chapterskip.nix { };
    convert = callPackage ./convert.nix { };
    cutter = callPackage ./cutter.nix { };
    inhibit-gnome = callPackage ./inhibit-gnome.nix { };
    modernx = callPackage ./modernx.nix { };
    modernx-zydezu = callPackage ./modernx-zydezu.nix { };
    mpris = callPackage ./mpris.nix { };
    mpv-cheatsheet = callPackage ./mpv-cheatsheet.nix { };
    mpv-osc-modern = callPackage ./mpv-osc-modern.nix { };
    mpv-playlistmanager = callPackage ./mpv-playlistmanager.nix { };
    mpv-webm = callPackage ./mpv-webm.nix { };
    mpvacious = callPackage ./mpvacious.nix { };
    quack = callPackage ./quack.nix { };
    quality-menu = callPackage ./quality-menu.nix { };
    reload = callPackage ./reload.nix { };
    simple-mpv-webui = callPackage ./simple-mpv-webui.nix { };
    sponsorblock = callPackage ./sponsorblock.nix { };
    sponsorblock-minimal = callPackage ./sponsorblock-minimal.nix { };
    thumbfast = callPackage ./thumbfast.nix { };
    thumbnail = callPackage ./thumbnail.nix { };
    uosc = callPackage ./uosc.nix { };
    visualizer = callPackage ./visualizer.nix { };
    vr-reversal = callPackage ./vr-reversal.nix { };
    webtorrent-mpv-hook = callPackage ./webtorrent-mpv-hook.nix { };
  };

  aliases = {
    youtube-quality = throw "'youtube-quality' is no longer maintained, use 'quality-menu' instead"; # added 2023-07-14
  };
in

with lib; pipe scope [
  (makeScope newScope)
  (self:
    assert builtins.intersectAttrs self aliases == {};
    self // optionalAttrs config.allowAliases aliases)
  recurseIntoAttrs
]
