{ config, lib, ... }:

{
  attrsOfSub.foo = lib.mkIf config.enable {
    enable = true;
  };
}
