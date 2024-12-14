{ lib, ... }:
let
  inherit (lib) mkOption types;

  moduleWithKey =
    { config, ... }:
    {
      config = {
        enable = true;
      };
    };
in
{
  imports = [
    ./declare-enable.nix
  ];
  disabledModules = [ { } ];
}
