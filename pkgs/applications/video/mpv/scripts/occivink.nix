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
      version = "unstable-2023-12-18";
      src = fetchFromGitHub {
        owner = "occivink";
        repo = "mpv-scripts";
        rev = "f0426bd6b107b1f4b124552dae923b62f58ce3b6";
        hash = "sha256-oag5lcDoezyNXs5EBr0r0UE3ikeftvbfxSzfbxV1Oy0=";
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
