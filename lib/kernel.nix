{ lib }:

let
  inherit (lib) mkIf versionAtLeast versionOlder;
in
{


  # Keeping these around in case we decide to change this horrible implementation :)
  option = x:
      x // { optional = true; };

  yes      = { tristate    = "y";  optional = false; };
  no       = { tristate    = "n";  optional = false; };
  module   = { tristate    = "m";  optional = false; };
  unset    = { tristate    = null; optional = false; };
  freeform = x: { freeform = x; optional = false; };


  #  Common patterns/legacy used in common-config/hardened/config.nix
  whenHelpers = version: {
    whenAtLeast = ver: mkIf (versionAtLeast version ver);
    whenOlder   = ver: mkIf (versionOlder version ver);
    # range is (inclusive, exclusive)
    whenBetween = verLow: verHigh: mkIf (versionAtLeast version verLow && versionOlder version verHigh);
  };

}
