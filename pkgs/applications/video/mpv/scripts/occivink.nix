{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
  ffmpeg,
}:

let
  camelToKebab =
    let
      inherit (lib.strings) match stringAsChars toLower;
      isUpper = match "[A-Z]";
    in
    stringAsChars (c: if isUpper c != null then "-${toLower c}" else c);

  mkScript =
    name: args:
    let
      self = rec {
        pname = camelToKebab name;
        version = "0-unstable-2024-01-11";
        src = fetchFromGitHub {
          owner = "occivink";
          repo = "mpv-scripts";
          rev = "d0390c8e802c2e888ff4a2e1d5e4fb040f855b89";
          hash = "sha256-pc2aaO7lZaoYMEXv5M0WI7PtmqgkNbdtNiLZZwVzppM=";
        };
        passthru.updateScript = unstableGitUpdater { };

        scriptPath = "scripts/${pname}.lua";

        meta = with lib; {
          homepage = "https://github.com/occivink/mpv-scripts";
          license = licenses.unlicense;
          maintainers = with maintainers; [ nicoo ];
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
    crop.meta.description = "Crop the current video in a visual manner";
    seekTo.meta.description = "Mpv script for seeking to a specific position";
    blacklistExtensions.meta.description = "Automatically remove playlist entries based on their extension";

    encode = {
      meta.description = "Make an extract of the video currently playing using ffmpeg";

      postPatch = ''
        substituteInPlace scripts/encode.lua \
            --replace-fail '"ffmpeg"' '"${lib.getExe ffmpeg}"'
      '';
    };
  }
)
