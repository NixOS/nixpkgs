let
  pinned = (builtins.fromJSON (builtins.readFile ./pinned.json)).pins;
in
{
  system ? builtins.currentSystem,

  nixpkgs ? null,
  nixPath ? "nixVersions.latest",
}:
let
  nixpkgs' =
    if nixpkgs == null then
      fetchTarball {
        inherit (pinned.nixpkgs) url;
        sha256 = pinned.nixpkgs.hash;
      }
    else
      nixpkgs;

  pkgs = import nixpkgs' {
    inherit system;
    # Nixpkgs generally — and CI specifically — do not use aliases,
    # because we want to ensure they are not load-bearing.
    allowAliases = false;
  };

  fmt =
    let
      treefmt = pkgs.treefmt.withConfig ./treefmt.nix;
      fs = pkgs.lib.fileset;
      nixFilesSrc = fs.toSource {
        root = ../.;
        fileset = fs.difference ../. (fs.maybeMissing ../.git);
      };
    in
    {
      pkg = treefmt;
      check = treefmt.check nixFilesSrc;
    };

  # nixos-render-docs and nixos-render-docs-redirects
  # Should be used from tree to build the matching in-tree documentation
  docPkgs = pkgs.extend (
    final: prev: {
      nixos-render-docs = final.callPackage ../pkgs/by-name/ni/nixos-render-docs/package.nix { };
      nixos-render-docs-redirects =
        final.callPackage ../pkgs/by-name/ni/nixos-render-docs-redirects/package.nix
          { };
    }
  );

in
rec {
  inherit pkgs fmt;
  codeownersValidator = pkgs.callPackage ./codeowners-validator { };

  # FIXME(lf-): it might be useful to test other Nix implementations
  # (nixVersions.stable and Lix) here somehow at some point to ensure we don't
  # have eval divergence.
  eval = pkgs.callPackage ./eval {
    nix = pkgs.lib.getAttrFromPath (pkgs.lib.splitString "." nixPath) pkgs;
  };

  # CI jobs
  lib-tests = import ../lib/tests/release.nix { inherit pkgs; };
  manual-nixos = (import ../nixos/release.nix { }).manual.${system} or null;
  manual-nixpkgs = (import ../doc { pkgs = docPkgs; });
  nixpkgs-vet = pkgs.callPackage ./nixpkgs-vet.nix {
    nix = pkgs.nixVersions.latest;
  };
  parse = pkgs.lib.recurseIntoAttrs {
    nix_latest = pkgs.callPackage ./parse.nix { nix = pkgs.nixVersions.latest; };
    nix_2_28 = pkgs.callPackage ./parse.nix { nix = pkgs.nixVersions.nix_2_28; };
    lix = pkgs.callPackage ./parse.nix { nix = pkgs.lix; };
    lix_latest = pkgs.callPackage ./parse.nix { nix = pkgs.lixPackageSets.latest.lix; };
  };
  shell = import ../shell.nix { inherit nixpkgs system; };
  tarball = import ../pkgs/top-level/make-tarball.nix {
    # Mirrored from top-level release.nix:
    nixpkgs = {
      outPath = pkgs.lib.cleanSource ../.;
      revCount = 1234;
      shortRev = "abcdef";
      revision = "0000000000000000000000000000000000000000";
    };
    officialRelease = false;
    inherit pkgs lib-tests;
    nix = pkgs.nixVersions.latest;
  };
}
