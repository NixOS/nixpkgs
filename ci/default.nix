let
  pinned = (builtins.fromJSON (builtins.readFile ./pinned.json)).pins;
in
{
  system ? builtins.currentSystem,

  nixpkgs ? null,
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
    config = {
      permittedInsecurePackages = [ "nix-2.3.18" ];
    };
    overlays = [ ];
  };

  fmt =
    let
      treefmtNixSrc = fetchTarball {
        inherit (pinned.treefmt-nix) url;
        sha256 = pinned.treefmt-nix.hash;
      };
      treefmtEval = (import treefmtNixSrc).evalModule pkgs {
        # Important: The auto-rebase script uses `git filter-branch --tree-filter`,
        # which creates trees within the Git repository under `.git-rewrite/t`,
        # notably without having a `.git` themselves.
        # So if this projectRootFile were the default `.git/config`,
        # having the auto-rebase script use treefmt on such a tree would make it
        # format all files in the _parent_ Git tree as well.
        projectRootFile = ".git-blame-ignore-revs";

        # Be a bit more verbose by default, so we can see progress happening
        settings.verbose = 1;

        # By default it's info, which is too noisy since we have many unmatched files
        settings.on-unmatched = "debug";

        programs.actionlint.enable = true;

        programs.keep-sorted.enable = true;

        # This uses nixfmt-rfc-style underneath,
        # the default formatter for Nix code.
        # See https://github.com/NixOS/nixfmt
        programs.nixfmt.enable = true;

        programs.yamlfmt = {
          enable = true;
          settings.formatter = {
            retain_line_breaks = true;
          };
        };
        settings.formatter.yamlfmt.excludes = [
          # Breaks helm templating
          "nixos/tests/k3s/k3s-test-chart/templates/*"
          # Aligns comments with whitespace
          "pkgs/development/haskell-modules/configuration-hackage2nix/main.yaml"
          # TODO: Fix formatting for auto-generated file
          "pkgs/development/haskell-modules/configuration-hackage2nix/transitive-broken.yaml"
        ];

        settings.formatter.editorconfig-checker = {
          command = "${pkgs.lib.getExe pkgs.editorconfig-checker}";
          options = [ "-disable-indent-size" ];
          includes = [ "*" ];
          priority = 1;
        };
      };
      fs = pkgs.lib.fileset;
      nixFilesSrc = fs.toSource {
        root = ../.;
        fileset = fs.difference ../. (fs.maybeMissing ../.git);
      };
    in
    {
      shell = treefmtEval.config.build.devShell;
      pkg = treefmtEval.config.build.wrapper;
      check = treefmtEval.config.build.check nixFilesSrc;
    };

in
{
  inherit pkgs fmt;
  requestReviews = pkgs.callPackage ./request-reviews { };
  codeownersValidator = pkgs.callPackage ./codeowners-validator { };

  # FIXME(lf-): it might be useful to test other Nix implementations
  # (nixVersions.stable and Lix) here somehow at some point to ensure we don't
  # have eval divergence.
  eval = pkgs.callPackage ./eval {
    nix = pkgs.nixVersions.latest;
  };

  # CI jobs
  lib-tests = import ../lib/tests/release.nix { inherit pkgs; };
  manual-nixos = (import ../nixos/release.nix { }).manual.${system} or null;
  manual-nixpkgs = (import ../doc { });
  manual-nixpkgs-tests = (import ../doc { }).tests;
  nixpkgs-vet = pkgs.callPackage ./nixpkgs-vet.nix { };
  parse = pkgs.lib.recurseIntoAttrs {
    latest = pkgs.callPackage ./parse.nix { nix = pkgs.nixVersions.latest; };
    lix = pkgs.callPackage ./parse.nix { nix = pkgs.lix; };
    minimum = pkgs.callPackage ./parse.nix { nix = pkgs.nixVersions.minimum; };
  };
  shell = import ../shell.nix { inherit nixpkgs system; };
}
