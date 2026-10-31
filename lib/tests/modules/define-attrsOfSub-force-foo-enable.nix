{ lib, ... }:

{
  attrsOfSub = lib.mkForce {
    foo.enable = false;
  };
}
