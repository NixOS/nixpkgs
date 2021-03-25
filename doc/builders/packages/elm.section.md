# Elm {#sec-elm}

To start a development environment do

```ShellSession
nix-shell -p elmPackages.elm elmPackages.elm-format
```

To update the Elm compiler, see <filename>nixpkgs/pkgs/development/compilers/elm/README.md</filename>.

To package Elm applications, [read about elm2nix](https://github.com/hercules-ci/elm2nix#elm2nix).
