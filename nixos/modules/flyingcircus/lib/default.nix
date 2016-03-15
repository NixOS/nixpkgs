/*
 * library of local helper functions for use within modules.flyingcircus
 */

let
  lib = import <nixpkgs/lib>;
  network = import ./network.nix { inherit lib; };
  math = import ./math.nix { inherit lib; };
in
  { inherit network math; }
  // network // math
