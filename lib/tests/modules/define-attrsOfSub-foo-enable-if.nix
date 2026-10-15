{ config, lib, ... }:

{
  attrsOfSub.foo.enable = lib.mkIf config.enable true;
}
