{ callPackage
, ...
}:

{
  passbook = callPackage ./passbook.nix { };
}
