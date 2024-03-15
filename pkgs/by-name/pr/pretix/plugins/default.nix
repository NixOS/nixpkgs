{ callPackage
, ...
}:

{
  pages = callPackage ./pages.nix { };

  passbook = callPackage ./passbook.nix { };
}
