{ lib, ... }:

lib.mkForce {
  attrsOfSub.foo.enable = false;
}
