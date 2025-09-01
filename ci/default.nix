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

        programs.biome = {
          enable = true;
          settings.formatter = {
            useEditorconfig = true;
          };
          settings.javascript.formatter = {
            quoteStyle = "single";
            semicolons = "asNeeded";
          };
          settings.json.formatter.enabled = false;
        };
        settings.formatter.biome.excludes = [
          "*.min.js"
          "pkgs/*"
        ];

        programs.keep-sorted.enable = true;

        # This uses nixfmt underneath, the default formatter for Nix code.
        # See https://github.com/NixOS/nixfmt
        programs.nixfmt = {
          enable = true;
          package = pkgs.nixfmt;
        };

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

        programs.nixf-diagnose.enable = true;
        settings.formatter.nixf-diagnose = {
          # Ensure nixfmt cleans up after nixf-diagnose.
          priority = -1;
          options = [
            "--auto-fix"
            # Rule names can currently be looked up here:
            # https://github.com/nix-community/nixd/blob/main/libnixf/src/Basic/diagnostic.py
            # TODO: Remove the following and fix things.
            "--ignore=sema-unused-def-lambda-noarg-formal"
            "--ignore=sema-unused-def-lambda-witharg-arg"
            "--ignore=sema-unused-def-lambda-witharg-formal"
            "--ignore=sema-unused-def-let"
            # Keep this rule, because we have `lib.or`.
            "--ignore=or-identifier"
          ];
          excludes = [
            # Auto-generated; violates sema-extra-with
            # Can only sensibly be removed when --auto-fix supports multiple fixes at once:
            # https://github.com/inclyc/nixf-diagnose/issues/13
            "pkgs/servers/home-assistant/component-packages.nix"
            # https://github.com/nix-community/nixd/issues/708
            "nixos/maintainers/scripts/azure-new/examples/basic/system.nix"
          ];
        };

        settings.formatter.editorconfig-checker = {
          command = "${pkgs.lib.getExe pkgs.editorconfig-checker}";
          options = [ "-disable-indent-size" ];
          includes = [ "*" ];
          priority = 1;
        };

        # TODO: Upstream this into treefmt-nix eventually:
        #   https://github.com/numtide/treefmt-nix/issues/387
        settings.formatter.markdown-code-runner = {
          command = pkgs.lib.getExe pkgs.markdown-code-runner;
          options =
            let
              config = pkgs.writers.writeTOML "markdown-code-runner-config" {
                presets.nixfmt = {
                  language = "nix";
                  command = [ (pkgs.lib.getExe pkgs.nixfmt) ];
                };
              };
            in
            [ "--config=${config}" ];
          includes = [ "*.md" ];
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
rec {
  inherit pkgs fmt;
  requestReviews = pkgs.callPackage ./request-reviews { };
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
  manual-nixpkgs = (import ../doc { inherit pkgs; });
  manual-nixpkgs-tests = (import ../doc { inherit pkgs; }).tests;
  nixpkgs-vet = pkgs.callPackage ./nixpkgs-vet.nix {
    nix = pkgs.nixVersions.latest;
  };
  parse = pkgs.lib.recurseIntoAttrs {
    latest = pkgs.callPackage ./parse.nix { nix = pkgs.nixVersions.latest; };
    lix = pkgs.callPackage ./parse.nix { nix = pkgs.lix; };
    nix_2_28 = pkgs.callPackage ./parse.nix { nix = pkgs.nixVersions.nix_2_28; };
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
