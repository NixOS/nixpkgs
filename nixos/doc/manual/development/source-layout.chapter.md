# Source Layout {#sec-source-layout}

NixOS has a modular system for declarative configuration. This system
evluates multiple *modules* to produce the full system configuration.

A standard set of modules in the [`nixos/modules`][nixos-modules-dir]
subdirectory of the Nixpkgs tree implements the default NixOS distribution.

These modules are called `baseModules` and the entire set is specified
in the [`nixos/modules/modules-list.nix`][modules-list-file] file.

Their tests, in turn, live in the [`nixos/tests`][nixos-tests-dir] subdirectory
of the Nixpkgs tree.

Furthermore, a library implements shared functionality for the use with NixOS.
This NixOS-specific library of Nix code lives in the [`nixos/lib`][nixos-lib-dir]
of the Nixpkgs tree.

Its two main domains are module and test evaluation. These are described in
further detail in the below sections. In addition, the library implements a
series of helper functions that can be used in modules or tests throughout
the [`nixos`][nixos-dir] subdirectory of the Nixpkgs tree, but they aren't a
public interface of the library.

[nixos-dir]: https://github.com/NixOS/nixpkgs/tree/master/nixos
[nixos-modules-dir]: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules
[modules-list-file]: https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/modules-list.nix
[nixos-lib-dir]: https://github.com/NixOS/nixpkgs/tree/master/nixos/lib
[nixos-tests-dir]: https://github.com/NixOS/nixpkgs/tree/master/nixos/tests

```{=include=} sections
lib-modules-eval.section.md
```
