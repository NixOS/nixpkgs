{ lib, ... }:
let
  inherit (lib) mkOption;
in
{
  options.sub = lib.mkOption {
    type = lib.types.submodule {
      wrong2 = mkOption { };
    };
    default = { };
  };
}
