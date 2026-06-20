{ pkgs, ... }: {
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
    # Disable settings validation because its inputs are liable to hash mismatch
    validate.enable = false;
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
    # Aligns comments with whitespace
    "pkgs/development/haskell-modules/configuration-hackage2nix/main.yaml"
    # TODO: Fix formatting for auto-generated file
    "pkgs/development/haskell-modules/configuration-hackage2nix/transitive-broken.yaml"
  ];

  programs.nixf-diagnose = {
    enable = true;
    ignore = [
      # Rule names can currently be looked up here:
      # https://github.com/nix-community/nixd/blob/main/libnixf/src/Basic/diagnostic.py
      # TODO: Remove the following and fix things.
      "sema-unused-def-lambda-noarg-formal"
      "sema-unused-def-lambda-witharg-arg"
      "sema-unused-def-lambda-witharg-formal"
      "sema-unused-def-let"
      # Keep this rule, because we have `lib.or`.
      "or-identifier"
      # TODO: remove after outstanding prelude diagnostics issues are fixed:
      # https://github.com/nix-community/nixd/issues/761
      # https://github.com/nix-community/nixd/issues/762
      "sema-primop-removed-prefix"
      "sema-primop-overridden"
      "sema-constant-overridden"
      "sema-primop-unknown"
    ];
  };
  settings.formatter.nixf-diagnose = {
    # Ensure nixfmt cleans up after nixf-diagnose.
    priority = -1;
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
    options = [
      "-disable-indent-size"
      # TODO: Remove this once this upstream issue is fixed:
      #   https://github.com/editorconfig-checker/editorconfig-checker/issues/505
      "-disable-charset"
    ];
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

  programs.zizmor.enable = true;
}
