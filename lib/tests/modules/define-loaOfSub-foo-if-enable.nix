{ config, lib, ... }:

{
  loaOfSub.foo = lib.mkIf config.enable {
    enable = true;
  };
}
