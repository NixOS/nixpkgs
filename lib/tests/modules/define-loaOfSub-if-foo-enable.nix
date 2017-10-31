{ config, lib, ... }:

{
  loaOfSub = lib.mkIf config.enable {
    foo.enable = true;
  };
}
