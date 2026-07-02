{
  lib,
  pkgs,
  ...
}:
{
  settings = {
    # numtide/treefmt-nix defaults
    excludes = [
      "*.lock"
      "*.patch"
      "*.diff"
      "package-lock.json"
      "go.mod"
      "go.sum"
      ".gitattributes"
      ".gitignore"
      ".gitmodules"
      "COPYING"
      "LICENSE"
    ];

    # Be a bit more verbose by default, so we can see progress happening
    verbose = 1;

    # By default it's info, which is too noisy since we have many unmatched files
    on-unmatched = "debug";

    formatter = {
      # keep-sorted start block=yes newline_separated=yes
      actionlint = {
        command = lib.getExe pkgs.actionlint;
        includes = [
          ".github/workflows/*.yml"
          ".github/workflows/*.yaml"
        ];
      };

      biome = {
        command = lib.getExe pkgs.biome;
        excludes = [
          "*.min.js"
          "pkgs/*"
        ];
        includes = [
          "*.js"
          "*.ts"
          "*.mjs"
          "*.mts"
          "*.cjs"
          "*.cts"
          "*.jsx"
          "*.tsx"
          "*.d.ts"
          "*.d.cts"
          "*.d.mts"
          "*.css"
        ];
        options = [
          "check"
          "--write"
          "--no-errors-on-unmatched"
          "--use-editorconfig=true"
          "--javascript-formatter-quote-style=single"
          "--semicolons=as-needed"
        ];
      };

      editorconfig-checker = {
        command = lib.getExe pkgs.editorconfig-checker;
        options = [
          "-disable-indent-size"
          # TODO: Remove this once this upstream issue is fixed:
          #   https://github.com/editorconfig-checker/editorconfig-checker/issues/505
          "-disable-charset"
        ];
        includes = [ "*" ];
        priority = 1;
      };

      keep-sorted = {
        command = lib.getExe pkgs.keep-sorted;
        includes = [ "*" ];
      };

      markdown-code-runner = {
        command = lib.getExe pkgs.markdown-code-runner;
        options =
          let
            config = pkgs.writers.writeTOML "markdown-code-runner-config" {
              presets.nixfmt = {
                language = "nix";
                command = [ (lib.getExe pkgs.nixfmt) ];
              };
            };
          in
          [ "--config=${config}" ];
        includes = [ "*.md" ];
      };

      nixf-diagnose = {
        command = lib.getExe pkgs.nixf-diagnose;
        excludes = [
          # Auto-generated; violates sema-extra-with
          # Can only sensibly be removed when --auto-fix supports multiple fixes at once:
          # https://github.com/inclyc/nixf-diagnose/issues/13
          "pkgs/servers/home-assistant/component-packages.nix"
          # https://github.com/nix-community/nixd/issues/708
          "nixos/maintainers/scripts/azure-new/examples/basic/system.nix"
        ];
        includes = [ "*.nix" ];
        options = [
          "--auto-fix"
          # Rule names can currently be looked up here:
          # https://github.com/nix-community/nixd/blob/main/libnixf/src/Basic/diagnostic.py
          # TODO: Remove the following and fix things.
          "--ignore=sema-unused-def-lambda-noarg-formal"
          "--ignore=sema-unused-def-lambda-witharg-arg"
          "--ignore=sema-unused-def-lambda-witharg-formal"
          "--ignore=sema-unused-def-let"
          # TODO: remove after outstanding prelude diagnostics issues are fixed:
          # https://github.com/nix-community/nixd/issues/761
          # https://github.com/nix-community/nixd/issues/762
          "--ignore=sema-primop-removed-prefix"
          "--ignore=sema-primop-overridden"
          "--ignore=sema-constant-overridden"
          "--ignore=sema-primop-unknown"
        ];
        # Ensure nixfmt cleans up after nixf-diagnose.
        priority = -1;
      };

      # This uses nixfmt underneath, the default formatter for Nix code.
      # See https://github.com/NixOS/nixfmt
      nixfmt = {
        command = lib.getExe pkgs.nixfmt;
        includes = [ "*.nix" ];
      };

      yamlfmt = {
        command = lib.getExe pkgs.yamlfmt;
        excludes = [
          # Aligns comments with whitespace
          "pkgs/development/haskell-modules/configuration-hackage2nix/main.yaml"
          # TODO: Fix formatting for auto-generated file
          "pkgs/development/haskell-modules/configuration-hackage2nix/transitive-broken.yaml"
        ];
        includes = [
          "*.yaml"
          "*.yml"
        ];
        options = [
          "-formatter"
          "retain_line_breaks=true"
        ];
      };

      zizmor = {
        command = lib.getExe pkgs.zizmor;
        includes = [
          ".github/workflows/*.yml"
          ".github/workflows/*.yaml"
          ".github/actions/**/*.yml"
          ".github/actions/**/*.yaml"
        ];
      };
      # keep-sorted end
    };
  };
}
