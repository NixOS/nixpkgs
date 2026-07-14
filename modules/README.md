# `<nixpkgs>/modules`

This directory hosts subdirectories representing each module [class](https://nixos.org/manual/nixpkgs/stable/#module-system-lib-evalModules-param-class) for which the `nixpkgs` repository has user-importable modules.

Exceptions:
- `_class = "nixos";` modules go in the `<nixpkgs>/nixos/modules` tree
- modules whose only purpose is to test code in this repository

The emphasis is on _importable_ modules, i.e. ones that aren't inherent to and built into the Module System application.
