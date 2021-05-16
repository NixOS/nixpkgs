# pkgs.mkShell {#sec-pkgs-mkShell}

`pkgs.mkShell` is a special kind of derivation that is only useful when using
it combined with `nix-shell`. It will in fact fail to instantiate when invoked
with `nix-build`.

## Usage {#sec-pkgs-mkShell-usage}

```nix
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  # specify which packages to add to the shell environment
  packages = [ pkgs.gnumake ];
  # add all the dependencies, of the given packages, to the shell environment
  inputsFrom = with pkgs; [ hello gnutar ];
}
```
