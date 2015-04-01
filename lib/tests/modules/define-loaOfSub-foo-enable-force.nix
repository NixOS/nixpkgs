{ lib, ... }:

{
  loaOfSub.foo.enable = lib.mkForce false;
}
