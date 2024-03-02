{ lib, ... }:
{
  options.bad = lib.mkOption {
    type = lib.types.nonEmptyListOf (lib.types.submodule { });
    default = [ ];
  };
}
