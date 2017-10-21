{ lib, ... }:

{
  loaOfSub.foo = lib.mkForce {
    enable = false;
  };
}
