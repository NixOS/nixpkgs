{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.bare-submodule.deep = mkOption {
    type = types.int;
    default = 2;
  };
}
