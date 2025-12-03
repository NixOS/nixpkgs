{ config, lib, ... }:

lib.mkIf config.enable {
  attrsOfSub.foo.enable = true;
}
