{ system ? builtins.currentSystem }:

{ pkgs =
    (import nixpkgs/default.nix { inherit system; })
    // { recurseForDerivations = true; };
}
