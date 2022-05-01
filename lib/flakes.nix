{ lib }:

rec {

  /* imports a flake.nix without acknowledging its lock file, useful for
    referencing subflakes from a parent flake. The second argument allows
    specifying the inputs of this flake.

    Example:
      callLocklessFlake {
        path = ./directoryContainingFlake;
        inputs = { inherit nixpkgs; };
      }
  */
  callLocklessFlake = { path, inputs ? { } }:
    let
      self = { outPath = path; } //
        ((import (path + "/flake.nix")).outputs (inputs // { self = self; }));
    in
    self;

}
