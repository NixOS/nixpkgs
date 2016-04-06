[<img src="http://nixos.org/logo/nixos-hires.png" width="500px" alt="logo" />](https://nixos.org/nixos)

[![Build Status](https://travis-ci.org/NixOS/nixpkgs.svg?branch=master)](https://travis-ci.org/NixOS/nixpkgs)
[![Issue Stats](http://www.issuestats.com/github/nixos/nixpkgs/badge/pr?style=flat)](http://www.issuestats.com/github/nixos/nixpkgs)
[![Issue Stats](http://www.issuestats.com/github/nixos/nixpkgs/badge/issue?style=flat)](http://www.issuestats.com/github/nixos/nixpkgs)

Nixpkgs is a collection of packages for the [Nix](https://nixos.org/nix/) package
manager. It is periodically built and tested by the [hydra](https://hydra.mayflower.de/)
build daemon as so-called channels. To get channel information via git, add
[nixpkgs-channels](https://github.com/NixOS/nixpkgs-channels.git) as a remote:

```
% git remote add channels git://github.com/NixOS/nixpkgs-channels.git
```

For stability and maximum binary package support, it is recommended to maintain
custom changes on top of one of the channels, e.g. `nixos-16.03` for the latest
release and `nixos-unstable` for the latest successful build of master:

```
% git remote update channels
% git rebase channels/nixos-16.03
```

For pull-requests, please rebase onto nixpkgs `master`.

[NixOS](https://nixos.org/nixos/) linux distribution source code is located inside
`nixos/` folder.

* [NixOS installation instructions](https://nixos.org/nixos/manual/#ch-installation)
* [Documentation (Nix Expression Language chapter)](https://nixos.org/nix/manual/#ch-expression-language)
* [Manual (How to write packages for Nix)](https://nixos.org/nixpkgs/manual/)
* [Manual (NixOS)](https://nixos.org/nixos/manual/)
* [Nix Wiki](https://nixos.org/wiki/)
* [Continuous package builds for unstable/master](https://hydra.nixos.org/jobset/nixos/trunk-combined)
* [Continuous package builds for 16.03 release](https://hydra.nixos.org/jobset/nixos/release-16.03)
* [Tests for unstable/master](https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents)
* [Tests for 16.03 release](https://hydra.nixos.org/job/nixos/release-16.03/tested#tabs-constituents)

Communication:

* [Mailing list](http://lists.science.uu.nl/mailman/listinfo/nix-dev)
* [IRC - #nixos on freenode.net](irc://irc.freenode.net/#nixos)
