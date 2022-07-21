rec {
  /* mkSymbol returns a value that is only comparable to itself. The main
     use is to create unique identifiers or labels and enables a form of weak
     encapsulation, or information hiding.

     The reason this works is that function equality works by comparing the
     memory location. So two mkSymbol calls with the same description will
     generate two different singletons.

     Usage:
       mkSymbol "mydescription"
  */
  mkSymbol = description:
    { __toString = _: description; };

  # ---- list of global symbols ----

  /* NOCHROOT is an argument that can be passed to various derivation
     constructors in nixpkgs and tell them to disable the Nix build sandbox
     instead of using a pre-computed Hash when fetching dependencies.

     For "__noChroot = true" to work on derivations, Nix has to be configured
     with "sandbox = relaxed".

     NOTE: This argument should never be used by nixpkgs packages themselves
           and is only meant for third-party usage.
  */
  NOCHROOT = mkSymbol "no-chroot";
}
