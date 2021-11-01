{ lib }:

with lib;
{


  # Keeping these around in case we decide to change this horrible implementation :)
  option = x:
      x // { optional = true; };

  yes      = { tristate    = "y"; optional = false; };
  no       = { tristate    = "n"; optional = false; };
  module   = { tristate    = "m"; optional = false; };
  freeform = x: { freeform = x; optional = false; };

  /*
    Common patterns/legacy used in common-config/hardened/config.nix
   */
  whenHelpers = version: {
    whenAtLeast = ver: mkIf (versionAtLeast version ver);
    whenOlder   = ver: mkIf (versionOlder version ver);
    # range is (inclusive, exclusive)
    whenBetween = verLow: verHigh: mkIf (versionAtLeast version verLow && versionOlder version verHigh);
  };

  # Normalize kernel versions as appropriate for modDirVersion
  versionToModDir = version:
    let parts = splitString "." version;
    in
      if length parts >= 3
      then version
      else if length parts == 2
      then let
          maj = builtins.elemAt parts 0;
          rem = splitString "-" (builtins.elemAt parts 1);
          min = builtins.head rem;
          postfix = builtins.concatStringsSep "-" (builtins.tail rem);
        in builtins.concatStringsSep "." [ maj min "0" ]
          + (if postfix != "" then "-${postfix}" else "")
      else throw "versionToModDir: don't know how to normalize version: ${version}";

}
