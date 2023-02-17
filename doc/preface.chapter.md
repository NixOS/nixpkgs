# Preface {#preface}

The Nix Packages collection (Nixpkgs) is a set of thousands of packages for the
[Nix package manager](https://nixos.org/nix/), released under a
[permissive MIT/X11 license](https://github.com/NixOS/nixpkgs/blob/master/COPYING).
Packages are available for several platforms, and can be used with the Nix
package manager on most GNU/Linux distributions as well as [NixOS](https://nixos.org/nixos).

This manual primarily describes how to write packages for the Nix Packages collection
(Nixpkgs). Thus it’s mainly for packagers and developers who want to add packages to
Nixpkgs. If you like to learn more about the Nix package manager and the Nix
expression language, then you are kindly referred to the [Nix manual](https://nixos.org/nix/manual/).
The NixOS distribution is documented in the [NixOS manual](https://nixos.org/nixos/manual/).

## Overview of Nixpkgs {#overview-of-nixpkgs}

Nix expressions describe how to build packages from source and are collected in
the [nixpkgs repository](https://github.com/NixOS/nixpkgs). Also included in the
collection are Nix expressions for
[NixOS modules](https://nixos.org/nixos/manual/index.html#sec-writing-modules).
With these expressions the Nix package manager can build binary packages.

Packages, including the Nix packages collection, are distributed through
[channels](https://nixos.org/nix/manual/#sec-channels). The collection is
distributed for users of Nix on non-NixOS distributions through the channel
`nixpkgs`. Users of NixOS generally use one of the `nixos-*` channels, e.g.
`nixos-22.11`, which includes all packages and modules for the stable NixOS
22.11. Stable NixOS releases are generally only given
security updates. More up to date packages and modules are available via the
`nixos-unstable` channel.

Both `nixos-unstable` and `nixpkgs` follow the `master` branch of the Nixpkgs
repository, although both do lag the `master` branch by generally
[a couple of days](https://status.nixos.org/). Updates to a channel are
distributed as soon as all tests for that channel pass, e.g.
[this table](https://hydra.nixos.org/job/nixpkgs/trunk/unstable#tabs-constituents)
shows the status of tests for the `nixpkgs` channel.

The tests are conducted by a cluster called [Hydra](https://nixos.org/hydra/),
which also builds binary packages from the Nix expressions in Nixpkgs for
`x86_64-linux`, `i686-linux` and `x86_64-darwin`.
The binaries are made available via a [binary cache](https://cache.nixos.org).

The current Nix expressions of the channels are available in the
[`nixpkgs`](https://github.com/NixOS/nixpkgs) repository in branches
that correspond to the channel names (e.g. `nixos-22.11-small`).
