# Preface {#preface}

This manual describes how to install, use and extend NixOS, a Linux distribution based on the purely functional package management system [Nix](https://nixos.org/nix), that is composed using modules and packages defined in the [Nixpkgs](https://nixos.org/nixpkgs) project.

Additional information regarding the Nix package manager and the Nixpkgs project can be found in respectively the [Nix manual](https://nixos.org/nix/manual) and the [Nixpkgs manual](https://nixos.org/nixpkgs/manual).

If you encounter problems, please report them on the [`Discourse`](https://discourse.nixos.org), the [Matrix room](https://matrix.to/#/%23nix:nixos.org), or on the [`#nixos` channel on Libera.Chat](irc://irc.libera.chat/#nixos). Alternatively, consider [contributing to this manual](#chap-contributing). Bugs should be reported in [NixOS’ GitHub issue tracker](https://github.com/NixOS/nixpkgs/issues).

::: {.note}
Commands prefixed with `#` have to be run as root, either by logging in
as the root user or by temporarily switching to it, for example using
`sudo -i` or `su -`. Prefer a *login* shell (note the `-i`/`-`): some
commands, such as `nix-channel`, read per-user state from the user's
`$HOME`, so a non-login `sudo`/`su` keeps your own environment instead
of root's and may act on the wrong user's data.
:::
