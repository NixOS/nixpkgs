{
  lib,
  runCommand,
  buildEnv,
  makeWrapper,
  writers,
  treefmt,
  nixfmt-rfc-style,
  nixfmt-tree,

  settings ? {
    # The default is warn, which would be too annoying for people who just care about Nix
    on-unmatched = "info";
    # Assumes the user is using Git, fails if it's not
    tree-root-file = ".git/index";

    formatter.nixfmt = {
      command = "nixfmt";
      includes = [ "*.nix" ];
    };
  },
  runtimePackages ? [
    nixfmt-rfc-style
  ],
}:
buildEnv {
  name = "nixfmt-tree";

  # Allows this derivation to be used as a shell providing both treefmt and nixfmt
  paths = [ treefmt ] ++ runtimePackages;
  pathsToLink = [ "/bin" ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postBuild = ''
    wrapProgram $out/bin/treefmt \
      --prefix PATH : $out/bin \
      --add-flags "--config-file ${writers.writeTOML "treefmt.toml" settings}"
  '';

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
        and `nixfmt` with your editors format-on-save feature.

      - To check formatting in CI, run the following in a checkout of your Git repository:
        ```
        treefmt --ci
        ```

      For more flexibility, you can customise this package using
      ```nix
      nixfmt-tree.override {
        settings = { /* treefmt config */ };
        runtimePackages = [ /* List any formatters here */ ];
      }
      ```

      Alternatively you can switch to the more fully-featured [treefmt-nix](https://github.com/numtide/treefmt-nix).
    '';
    # All the code is in this file, so same license as Nixpkgs
    license = lib.licenses.mit;
    maintainers = lib.teams.formatter.members;
    platforms = lib.platforms.all;
  };

  passthru.tests.simple = runCommand "nixfmt-tree-test-simple" { } ''
    export XDG_CACHE_HOME=$(mktemp -d)
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
      mkdir .git dir
      touch .git/index
      cp ../unformatted.nix a.nix
      cp ../unformatted.nix dir/b.nix

      ${lib.getExe nixfmt-tree} dir
      if [[ "$(<dir/b.nix)" != "$(<../formatted.nix)" ]]; then
        echo "File dir/b.nix was not formatted properly after dir was requested to be formatted"
        exit 1
      elif [[ "$(<a.nix)" != "$(<../unformatted.nix)" ]]; then
        echo "File a.nix was formatted when only dir was requested to be formatted"
        exit 1
      fi

      (
        cd dir
        ${lib.getExe nixfmt-tree}
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
