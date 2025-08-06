{
  # The pkgs used for dependencies for the testing itself
  # Don't test properties of pkgs.lib, but rather the lib in the parent directory
  system ? builtins.currentSystem,
  pkgs ?
    import ../.. {
      inherit system;
      config = {
        permittedInsecurePackages = [ "nix-2.3.18" ];
      };
    }
    // {
      lib = throw "pkgs.lib accessed, but the lib tests should use nixpkgs' lib path directly!";
    },
  # For testing someone may edit impure.nix to return cross pkgs, use `pkgsBuildBuild` directly so everything here works.
  pkgsBB ? pkgs.pkgsBuildBuild,
  nix ? pkgs-nixVersions.stable,
  nixVersions ? [
    pkgs-nixVersions.minimum
    nix
    pkgs-nixVersions.latest
  ],
  pkgs-nixVersions ? import ./nix-for-tests.nix { pkgs = pkgsBB; },
}:

let
  lib = import ../.;
  testWithNix =
    nix:
    import ./test-with-nix.nix {
      inherit lib nix;
      pkgs = pkgsBB;
    };

in
pkgsBB.symlinkJoin {
  name = "nixpkgs-lib-tests";
  paths = map testWithNix nixVersions ++ [
    (import ./maintainers.nix {
      inherit pkgs;
      lib = import ../.;
    })
    (import ./teams.nix {
      inherit pkgs;
      lib = import ../.;
    })
  ];
}
