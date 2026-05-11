{
  pkgs ? (import ../ci { }).docPkgs,
  # The package set whose modular services are documented.
  # `pkgs` provides the documentation tooling and comes from a pinned Nixpkgs,
  # so it cannot be used here: the manual has to describe the services of the
  # tree it is built from.
  treePkgs ? import ../. { inherit (pkgs.stdenv.hostPlatform) system; },
  nixpkgs ? { },
}:

let
  bundledModularServiceModules = pkgs.lib.mapAttrs (_: pkg: pkg.services) (
    import ../pkgs/top-level/modular-services-bundled.nix treePkgs
  );
in
pkgs.callPackage ./doc-support/package.nix { inherit nixpkgs bundledModularServiceModules; }
