{ lib, ... }:
let
  myconf = lib.evalModules { modules = [ { } ]; };
in
{
  imports = [
    # We can't do this. A configuration is not equal to its set of a modules.
    # Equating those would lead to a mess, as specialArgs, anonymous modules
    # that can't be deduplicated, and possibly more come into play.
    myconf
  ];
}
