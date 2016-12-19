{ config, lib, ... }:

lib.mkIf config.enable {
  loaOfSub.foo.enable = true;
}
