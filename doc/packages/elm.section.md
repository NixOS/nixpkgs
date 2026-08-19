# Elm {#sec-elm}

To start a development environment, run:

```ShellSession
nix-shell -p elmPackages.elm elmPackages.elm-format
```

To update the Elm compiler, see `nixpkgs/pkgs/development/compilers/elm/README.md`.

To package Elm applications, [read about elm2nix](https://github.com/hercules-ci/elm2nix#elm2nix).
