/*
 * library of local helper functions for use within modules.flyingcircus
 */

let
  lib = import <nixpkgs/lib>;
  network = import ./network.nix { inherit lib; };
  math = import ./math.nix { inherit lib; };
  system = import ./system.nix { inherit lib; fclib=fclib; };

  fclib =
    { inherit network math system; }
    // network // math // system;

in
  fclib
