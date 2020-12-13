# pkgs.mkShell {#sec-pkgs-mkShell}

`pkgs.mkShell` is a special kind of derivation that is only useful when using it combined with `nix-shell`. It will in fact fail to instantiate when invoked with `nix-build`.

## Usage {#sec-pkgs-mkShell-usage}

```nix
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  # this will make all the build inputs from hello and gnutar
  # available to the shell environment
  inputsFrom = with pkgs; [ hello gnutar ];
  buildInputs = [ pkgs.gnumake ];
}
```
