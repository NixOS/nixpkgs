{ callPackage
, ...
}:

{
  pages = callPackage ./pages.nix { };

  passbook = callPackage ./passbook.nix { };

  reluctant-stripe = callPackage ./reluctant-stripe.nix { };

  stretchgoals = callPackage ./stretchgoals.nix { };

  zugferd = callPackage ./zugferd.nix { };
}
