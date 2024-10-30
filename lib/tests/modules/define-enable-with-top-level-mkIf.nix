{ lib, ... }:
# I think this might occur more realistically in a submodule
{
  imports = [ (lib.mkIf true { enable = true; }) ];
}
