{ config, lib, ... }:

{
  attrsOfSub = lib.mkIf config.enable {
    foo.enable = true;
  };
}
