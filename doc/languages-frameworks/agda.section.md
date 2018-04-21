---
title: Agda in Nixpkgs
author: Langston Barrett (@siddharthist)
date: 2018-04-21
---
# Agda

Everything is exposed to the user via the `agda` attribute.

## Installing the compiler (with libraries)

If you just want a shell with Agda available, run
```
nix run nixpkgs.haskellPackages.Agda
```
If you want to install Agda in your user profile, run
```
nix-env -iA nixos.haskellPackages.Agda 
```

<!-- TODO: does the following work with `nix run`? If so, how? -->

If you need certain libraries, you can use the function `withPackages`:
```
nix-shell -p "agda.withPackages [AgdaStdlib]"
```
For instance, if you're working on adding a new Agda library `myNewPackage` to
nixpkgs, you can test it out by running
```
nix-shell -I nixpkgs=$PWD -p "agda.withPackages [myNewPackage]"
```

## Building a binary with GHC

This is not yet implemented.
