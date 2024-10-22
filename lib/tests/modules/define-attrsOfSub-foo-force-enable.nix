{ lib, ... }:

{
  attrsOfSub.foo = lib.mkForce {
    enable = false;
  };
}
