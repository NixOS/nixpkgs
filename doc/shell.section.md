---
title: pkgs.mkShell
author: zimbatm
date: 2017-10-30
---

# mkShell

pkgs.mkShell is a special kind of derivation that is only useful when using
it combined with nix-shell. It will in fact fail to instantiate when invoked
with nix-build.

## Usage

```nix
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  # this will make all the build inputs from hello and gnutar available to the shell environment
  inputsFrom = with pkgs; [ hello gnutar ];
  buildInputs = [ pkgs.gnumake ];
}
```
