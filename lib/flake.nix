{
  description = "Library of low-level helper functions for nix expressions.";

  outputs = { self }:
    let
      lib' = import ./.;
    in {
      lib = lib'.extend (import ./__flake-version-info.nix self);
    };
}
