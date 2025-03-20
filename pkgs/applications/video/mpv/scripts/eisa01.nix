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
        version = "0-unstable-2023-11-25";

        src = fetchFromGitHub {
          owner = "Eisa01";
          repo = "mpv-scripts";
          rev = "48d68283cea47ff8e904decc9003b3abc3e2123e";
          hash = "sha256-edJfotlC5T8asqPIygR67BEWjP4i54Wx54StLfjpc48=";
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

    smartskip = {
      scriptPath = "scripts/SmartSkip.lua";
      meta = {
        description = "Automatically or manually skip opening, intro, outro, and preview";
        maintainers = with lib.maintainers; [ iynaix ];
      };
    };
  }
)
