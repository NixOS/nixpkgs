{
  lib,
  runCommand,
  treefmt,
  nixfmt,
  nixfmt-tree,
  git,
  writableTmpDirAsHomeHook,

  settings ? { },
  runtimeInputs ? [ ],
  nixfmtPackage ? nixfmt,

  # NOTE: `runtimePackages` is deprecated. Use `nixfmtPackage` and/or `runtimeInputs`.
  runtimePackages ? [ nixfmtPackage ],
}@args:
let
  allRuntimeInputs = runtimePackages ++ runtimeInputs;

  # Tests whether a package's main program is nixfmt.
  isNixfmt = p: p.meta.mainProgram or null == "nixfmt";

  treefmtWithConfig = treefmt.withConfig {
    name = "nixfmt-tree";

    settings = lib.mkMerge [
      # Default settings
      {
        _file = ./package.nix;

        # Log level for files treefmt won't format
        # The default is warn, which would be too annoying for people who just care about Nix
        on-unmatched = lib.mkOptionDefault "info";

        # NOTE: The `mkIf` condition should not be needed once `runtimePackages` is removed.
        formatter.nixfmt = lib.mkIf (lib.any isNixfmt allRuntimeInputs) {
          command = "nixfmt";
          includes = [ "*.nix" ];
        };
      }
      # User supplied settings
      {
        _file = "<nixfmt-tree args>";
        imports = lib.toList settings;
      }
    ];

    runtimeInputs =
      # Handle `runtimePackages` deprecation (added 2025-04-01)
      lib.warnIf (args ? runtimePackages) ''
        nixfmt-tree: overriding `runtimePackages` is deprecated, use `runtimeInputs` instead.
        Note: you do not need to supply a nixfmt package when using `runtimeInputs`, however you can override `nixfmtPackage` to a different nixfmt package.
        For additional flexibility, or to configure treefmt without nixfmt, consider using `treefmt.withConfig` instead of `nixfmt-tree`.
      '' allRuntimeInputs;
  };
in
treefmtWithConfig.overrideAttrs {
  meta = {
    mainProgram = "treefmt";
    description = "Official Nix formatter zero-setup starter using treefmt";
    longDescription = ''
      A zero-setup [treefmt](https://treefmt.com/) starter to get started using the [official Nix formatter](https://github.com/NixOS/nixfmt).

      - For `nix fmt` to format all Nix files, add this to the `flake.nix` outputs:

        ```nix
        formatter.''${system} = nixpkgs.legacyPackages.''${system}.nixfmt-tree;
        ```

      - The same can be done more efficiently with the `treefmt` command,
        which you can get in `nix-shell`/`nix develop` by extending `mkShell` using

        ```nix
        mkShell {
          packages = [ pkgs.nixfmt-tree ];
        }
        ```

        You can then also use `treefmt` in a pre-commit/pre-push [Git hook](https://git-scm.com/docs/githooks)
        and with your editor's format-on-save feature.

      - To check formatting in CI, run the following in a checkout of your Git repository:
        ```
        treefmt --ci
        ```

      For more flexibility, you can customise this package using
      ```nix
      pkgs.nixfmt-tree.override {
        settings = { /* additional treefmt config */ };
        runtimeInputs = [ /* additional formatter packages */ ];
      }
      ```

      You can achieve similar results by manually configuring `treefmt`:
      ```nix
      pkgs.treefmt.withConfig {
        runtimeInputs = [ pkgs.nixfmt-rfc-style ];

        settings = {
          # Log level for files treefmt won't format
          on-unmatched = "info";

          # Configure nixfmt for .nix files
          formatter.nixfmt = {
            command = "nixfmt";
            includes = [ "*.nix" ];
          };
        };
      }
      ```

      Alternatively you can switch to the more fully-featured [treefmt-nix](https://github.com/numtide/treefmt-nix).
    '';
    # All the code is in this file, so same license as Nixpkgs
    license = lib.licenses.mit;
    teams = [ lib.teams.formatter ];
    platforms = lib.platforms.all;
  };

  passthru.tests.simple =
    runCommand "nixfmt-tree-test-simple"
      {
        nativeBuildInputs = [
          git
          nixfmt-tree
          writableTmpDirAsHomeHook
        ];
      }
      ''
        git config --global user.email "nix-builder@nixos.org"
        git config --global user.name "Nix Builder"

        cat > unformatted.nix <<EOF
        let to = "be formatted"; in to
        EOF

        cat > formatted.nix <<EOF
        let
          to = "be formatted";
        in
        to
        EOF

        mkdir -p repo
        (
          cd repo
          mkdir dir
          cp ../unformatted.nix a.nix
          cp ../unformatted.nix dir/b.nix

          git init
          git add .
          git commit -m "Initial commit"

          treefmt dir
          if [[ "$(<dir/b.nix)" != "$(<../formatted.nix)" ]]; then
            echo "File dir/b.nix was not formatted properly after dir was requested to be formatted"
            exit 1
          elif [[ "$(<a.nix)" != "$(<../unformatted.nix)" ]]; then
            echo "File a.nix was formatted when only dir was requested to be formatted"
            exit 1
          fi

          (
            cd dir
            treefmt
          )

          if [[ "$(<a.nix)" != "$(<../formatted.nix)" ]]; then
            echo "File a.nix was not formatted properly after running treefmt without arguments in dir"
            exit 1
          fi
        )

        echo "Success!"

        touch $out
      '';
}
