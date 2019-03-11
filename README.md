[<img src="https://nixos.org/logo/nixos-hires.png" width="500px" alt="logo" />](https://nixos.org/nixos)

[![Code Triagers Badge](https://www.codetriage.com/nixos/nixpkgs/badges/users.svg)](https://www.codetriage.com/nixos/nixpkgs)

Nixpkgs is a collection of packages for the [Nix](https://nixos.org/nix/) package
manager. It is periodically built and tested by the [Hydra](https://hydra.nixos.org/)
build daemon as so-called channels. To get channel information via git, add
[nixpkgs-channels](https://github.com/NixOS/nixpkgs-channels.git) as a remote:

```
% git remote add channels https://github.com/NixOS/nixpkgs-channels.git
```

For stability and maximum binary package support, it is recommended to maintain
custom changes on top of one of the channels, e.g. `nixos-18.09` for the latest
release and `nixos-unstable` for the latest successful build of master:

```
% git remote update channels
% git rebase channels/nixos-18.09
```

For pull requests, please rebase onto nixpkgs `master`.

[NixOS](https://nixos.org/nixos/) Linux distribution source code is located inside
`nixos/` folder.

* [NixOS installation instructions](https://nixos.org/nixos/manual/#ch-installation)
* [Documentation (Nix Expression Language chapter)](https://nixos.org/nix/manual/#ch-expression-language)
* [Manual (How to write packages for Nix)](https://nixos.org/nixpkgs/manual/)
* [Manual (NixOS)](https://nixos.org/nixos/manual/)
* [Community maintained wiki](https://nixos.wiki/)
* [Continuous package builds for unstable/master](https://hydra.nixos.org/jobset/nixos/trunk-combined)
* [Continuous package builds for 18.09 release](https://hydra.nixos.org/jobset/nixos/release-18.09)
* [Tests for unstable/master](https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents)
* [Tests for 18.09 release](https://hydra.nixos.org/job/nixos/release-18.09/tested#tabs-constituents)

Communication:

* [Discourse Forum](https://discourse.nixos.org/)
* [IRC - #nixos on freenode.net](irc://irc.freenode.net/#nixos)

Note: MIT license does not apply to the packages built by Nixpkgs, merely to
the package descriptions (Nix expressions, build scripts, and so on). It also
might not apply to patches included in Nixpkgs, which may be derivative works
of the packages to which they apply. The aforementioned artifacts are all
covered by the licenses of the respective packages.
