{
  description = "Library of low-level helper functions for nix expressions.";

  outputs =
    { self }:
    let
      lib0 = import ./.;
    in
    {
      lib = lib0.extend (import ./flake-version-info.nix self);
    };
}
