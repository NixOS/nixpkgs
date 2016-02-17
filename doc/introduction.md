---
title: Introduction
author: Frederik Rietdijk
date: 2015-11-25
---

# Introduction

The Nix Packages collection (Nixpkgs) is a set of over 30,000 packages for the
[Nix package manager](http://nixos.org/nix/), released under a [permissive MIT/X11 license](https://github.com/NixOS/nixpkgs/blob/master/COPYING).
Packages are available for several architectures, and can be used with the Nix package manager
on most GNU/Linux distributions as well as NixOS.

This manual describes how to write packages for the Nix Packages collection
(Nixpkgs). Thus it’s for packagers and developers who want to add packages to
Nixpkgs. If you like to learn more about the Nix package manager and the Nix
expression language, then you are kindly referred to the [Nix manual](http://nixos.org/nix/manual/).

## Overview of Nixpkgs

Nix expressions describe how to build packages from source and are collected in
the [nixpkgs repository](https://github.com/NixOS/nixpkgs). Also included in the
collection are Nix expressions for [NixOS modules](http://nixos.org/nixos/manual/index.html#sec-writing-modules). With
these expressions the Nix package manager can build binary packages.

Packages, including the Nix packages collection, are distributed through
[channels](http://nixos.org/nix/manual/#sec-channels). The collection is
distributed for users of Nix on non-NixOS distributions through the channel
`nixpkgs`. Users of NixOS generally use one of the `nixos-*` channels, e.g.
`nixos-15.09`, which includes all packages and modules for the stable NixOS
15.09. The channels of the stable NixOS releases are generally only given
security updates. More up to date packages and modules are available via the
`nixos-unstable` channel.

Both `nixos-unstable` and `nixpkgs` follow the `master` branch of the Nixpkgs
repository, although both do lag the `master` branch by generally [a couple of days](http://howoldis.herokuapp.com/). Updates to a channel are distributed as
soon as all tests for that channel pass, e.g. [this table](http://hydra.nixos.org/job/nixpkgs/trunk/unstable#tabs-constituents)
shows the status of tests for the `nixpkgs` channel.

The tests are conducted by a cluster called [Hydra](http://nixos.org/hydra/),
which also builds binary packages from the Nix expressions in Nixpkgs. As soon
as a channel is updated, the binaries are made available via a [binary cache](https://cache.nixos.org). Until the channel updates, binaries that have
already been built, are available via [Hydra's binary cache](https://hydra.nixos.org).

The current Nix expressions of the channels are available in the
[`nixpkgs-channels`](https://github.com/NixOS/nixpkgs-channels) repository,
which has branches corresponding to the available channels. There is also the
Nixpkgs Monitor which keeps track of updates and security vulnerabilities.
