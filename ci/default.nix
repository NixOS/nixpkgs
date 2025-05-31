let
  pinnedNixpkgs = builtins.fromJSON (builtins.readFile ./pinned-nixpkgs.json);
in
{
  system ? builtins.currentSystem,

  nixpkgs ? null,
}:
let
  nixpkgs' =
    if nixpkgs == null then
      fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/${pinnedNixpkgs.rev}.tar.gz";
        sha256 = pinnedNixpkgs.sha256;
      }
    else
      nixpkgs;

  pkgs = import nixpkgs' {
    inherit system;
    config = { };
    overlays = [ ];
  };

  fmt =
    let
      treefmtNixSrc = fetchTarball {
        # Master at 2025-02-12
        url = "https://github.com/numtide/treefmt-nix/archive/4f09b473c936d41582dd744e19f34ec27592c5fd.tar.gz";
        sha256 = "051vh6raskrxw5k6jncm8zbk9fhbzgm1gxpq9gm5xw1b6wgbgcna";
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
  eval = pkgs.callPackage ./eval { };

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
