{ config, lib, ... }:

{
  loaOfSub.foo.enable = lib.mkIf config.enable true;
}
