{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.bare-submodule = mkOption {
    type = types.submoduleWith {
      modules = [ ];
    };
    default = {};
  };
}
