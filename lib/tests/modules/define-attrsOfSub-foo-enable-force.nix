{ lib, ... }:

{
  attrsOfSub.foo.enable = lib.mkForce false;
}
