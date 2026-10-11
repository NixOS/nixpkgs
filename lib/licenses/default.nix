{ lib }:
let
  licenses = import ./licenses.nix { inherit lib; };
  operators = import ./operators.nix;
  helpers = import ./helpers.nix { inherit lib; };
in
licenses // operators // helpers
