{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
  xclip,
}:

let
  mkScript =
    pname: args:
    let
      self = {
        inherit pname;
        version = "0-unstable-2025-05-14";

        src = fetchFromGitHub {
          owner = "Eisa01";
          repo = "mpv-scripts";
          rev = "100fea81ae8560c6fb113b1f6bb20857a41a5705";
          hash = "sha256-bMEKsHrJ+mgG7Vqpzj4TAr7Hehq2o2RuneowhrDCd5k=";
          # avoid downloading screenshots and videos
          sparseCheckout = [
            "scripts/"
            "script-opts/"
          ];
        };
        passthru.updateScript = unstableGitUpdater { };

        meta = with lib; {
          homepage = "https://github.com/Eisa01/mpv-scripts";
          license = licenses.bsd2;
        };

        # Sadly needed to make `common-updaters` work here
        pos = builtins.unsafeGetAttrPos "version" self;
      };
    in
    buildLua (lib.attrsets.recursiveUpdate self args);
in
lib.recurseIntoAttrs (
  lib.mapAttrs (name: lib.makeOverridable (mkScript name)) {

    # Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.seekTo ]; }`
    smart-copy-paste-2 = {
      scriptPath = "scripts/SmartCopyPaste_II.lua";
      prePatch = ''
        substituteInPlace $scriptPath --replace-fail 'xclip' "${lib.getExe xclip}"
      '';

      meta = {
        description = "Smart copy paste with logging and clipboard support";
        maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
      };
    };

    simplebookmark = {
      scriptPath = "scripts/SimpleBookmark.lua";
      meta = {
        description = "Simple bookmarks script based on assigning keys";
        maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
      };
    };

    simplehistory = {
      scriptPath = "scripts/SimpleHistory.lua";
      meta = {
        description = "Store videos in a history file, continue watching your last played or resume previously played videos, manage and play from your history, and more";
        maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
      };
    };

    smartskip = {
      scriptPath = "scripts/SmartSkip.lua";
      meta = {
        description = "Automatically or manually skip opening, intro, outro, and preview";
        maintainers = with lib.maintainers; [ iynaix ];
      };
    };

    undoredo = {
      scriptPath = "scripts/UndoRedo.lua";
      meta = {
        description = "Undo / redo any accidental time jumps";
        maintainers = with lib.maintainers; [ iynaix ];
      };
    };
  }
)
