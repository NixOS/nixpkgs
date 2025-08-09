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
        version = "0-unstable-2025-03-09";
        src = fetchFromGitHub {
          owner = "occivink";
          repo = "mpv-scripts";
          rev = "65aa1da29570e9c21b49292725ec5dd719ab6bb4";
          hash = "sha256-pca24cZY2ZNxkY1XP2T2WKo1UbD8gsGn+EskGH+CggE=";
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
