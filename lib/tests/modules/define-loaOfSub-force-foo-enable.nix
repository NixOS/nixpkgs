{ lib, ... }:

{
  loaOfSub = lib.mkForce {
    foo.enable = false;
  };
}
