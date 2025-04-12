{ # The pkgs used for dependencies for the testing itself
  # Don't test properties of pkgs.lib, but rather the lib in the parent directory
  pkgs ? import ../.. {} // { lib = throw "pkgs.lib accessed, but the lib tests should use nixpkgs' lib path directly!"; },
  nix ? pkgs-nixVersions.stable,
  nixVersions ? [ pkgs-nixVersions.minimum nix pkgs-nixVersions.latest ],
  pkgs-nixVersions ? import ./nix-for-tests.nix { inherit pkgs; },
}:

let
  lib = import ../.;
  testWithNix = nix:
    import ./test-with-nix.nix { inherit lib nix pkgs; };

in
  pkgs.symlinkJoin {
    name = "nixpkgs-lib-tests";
    paths = map testWithNix nixVersions;
  }
