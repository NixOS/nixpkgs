{ lib }:

with lib;
{


  # Keeping these around in case we decide to change this horrible implementation :)
  option = x:
      x // { optional = true; };

  yes      = { tristate    = "y"; };
  no       = { tristate    = "n"; };
  module   = { tristate    = "m"; };
  freeform = x: { freeform = x; };

  /*
    Common patterns/legacy used in common-config/hardened/config.nix
   */
  whenHelpers = version: {
    whenAtLeast = ver: mkIf (versionAtLeast version ver);
    whenOlder   = ver: mkIf (versionOlder version ver);
    # range is (inclusive, exclusive)
    whenBetween = verLow: verHigh: mkIf (versionAtLeast version verLow && versionOlder version verHigh);
  };

}
