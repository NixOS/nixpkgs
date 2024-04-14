{ lib
, fetchFromGitHub
, unstableGitUpdater
, buildLua
}:

let
  camelToKebab = let
    inherit (lib.strings) match stringAsChars toLower;
    isUpper = match "[A-Z]";
  in stringAsChars (c: if isUpper c != null then "-${toLower c}" else c);

  mkScript = name: args:
    let self = rec {
      pname = camelToKebab name;
      version = "unstable-2024-01-11";
      src = fetchFromGitHub {
        owner = "occivink";
        repo = "mpv-scripts";
        rev = "d0390c8e802c2e888ff4a2e1d5e4fb040f855b89";
        hash = "sha256-pc2aaO7lZaoYMEXv5M0WI7PtmqgkNbdtNiLZZwVzppM=";
      };
      passthru.updateScript = unstableGitUpdater {};

      scriptPath = "scripts/${pname}.lua";

      meta = with lib; {
        homepage = "https://github.com/occivink/mpv-scripts";
        license = licenses.unlicense;
        maintainers = with maintainers; [ nicoo ];
      };

      # Sadly needed to make `common-updaters` work here
      pos = builtins.unsafeGetAttrPos "version" self;
    };
    in buildLua (lib.attrsets.recursiveUpdate self args);

in
lib.mapAttrs (name: lib.makeOverridable (mkScript name)) {

  # Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.seekTo ]; }`
  seekTo.meta.description = "Mpv script for seeking to a specific position";
  blacklistExtensions.meta.description =
    "Automatically remove playlist entries based on their extension.";
}
