/* Collection of functions and constants specific to NixOS */
{ lib }:
let
  inherit (lib) versions strings;
in rec {
  # arbitrarily chosen, needs to be >99
  # needs to be != 100, that would defeat the point
  stateVersionBase = 149;

  encodeStateVersion = v:
    let parts = versions.splitVersion v;
        numbers = map strings.toInt parts;
     in lib.foldl' (acc: digit: acc * stateVersionBase + digit) 0 numbers;

  decodeStateVersion = v:
    let parts = n: if n == 0 then [] else [ (lib.mod n stateVersionBase) ] ++ parts (n / stateVersionBase);
        numbers = lib.reverseList (parts v);
        version = lib.concatMapStringsSep "." (strings.fixedWidthNumber 2) numbers;
    in version;

  sanityCheckStateVersion = newestPossibleVersion: version:
    let minor = versions.minor version;
        validMinorVersions = [ "03" "09" ];
        validMinor = lib.elem minor validMinorVersions;
        notNewerThanNixpkgs = lib.versionAtLeast newestPossibleVersion version;
    in validMinor && notNewerThanNixpkgs;
}
