# Package Management {#sec-package-management}

This section describes how to add additional packages to your system.
NixOS has two distinct styles of package management:

-   *Declarative*, where you declare what packages you want in your
    `configuration.nix`. Every time you run `nixos-rebuild`, NixOS will
    ensure that you get a consistent set of binaries corresponding to
    your specification.

-   *Ad hoc*, where you install, upgrade and uninstall packages via the
    `nix-env` command. This style allows mixing packages from different
    Nixpkgs versions. It's the only choice for non-root users.

```{=include=} sections
declarative-packages.section.md
ad-hoc-packages.section.md
```
