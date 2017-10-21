{ lib, ... }:

lib.mkForce {
  loaOfSub.foo.enable = false;
}
