# Configuration Syntax {#sec-configuration-syntax}

The NixOS configuration file `/etc/nixos/configuration.nix` is actually
a *Nix expression*, which is the Nix package manager's purely functional
language for describing how to build packages and configurations. This
means you have all the expressive power of that language at your
disposal, including the ability to abstract over common patterns, which
is very useful when managing complex systems. The syntax and semantics
of the Nix language are fully described in the [Nix
manual](https://nixos.org/nix/manual/#chap-writing-nix-expressions), but
here we give a short overview of the most important constructs useful in
NixOS configuration files.

```{=include=} sections
config-file.section.md
abstractions.section.md
modularity.section.md
```
