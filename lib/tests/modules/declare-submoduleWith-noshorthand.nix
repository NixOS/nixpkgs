{ lib, ... }:
let
  sub.options.config = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };
in
{
  options.submodule = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [ sub ];
    };
    default = { };
  };
}
