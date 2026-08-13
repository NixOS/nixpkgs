{ lib, ... }:
{
  imports = [
    ./declare-enable.nix
  ];
  disabledModules = [ { } ];
}
