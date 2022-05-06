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

  /* Generates an attrset for the given list of system strings and instantiates
    nixpkgs from a given flake. The system architecture string for each set is
    available via the 'system' argument. The instantiated nixpkgs set is available
    via the 'pkgs' argument.

    Type: forSystems :: [String] -> Flake -> ( String -> AttrSet -> t ) -> AttrSet

    Example:
      nixpkgs.lib.forSystems
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ]
        (builtins.getFlake "github:nixos/nixpkgs")
        (system: pkgs: { x = pkgs.hello; })

      The example will return:
        { aarch64-darwin = { ... }; aarcH64-linux = { ... }; x86_64-darwin = { ... }; x86_64-linux = { ... }; }
  */
  legacyPackagesForSystems = systems: flake: f:
    lib.genAttrs systems
    (system: f system flake.legacyPackages.${system});

}
