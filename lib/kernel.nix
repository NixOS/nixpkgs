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

}
