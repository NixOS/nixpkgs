<p align="center">
  <a href="https://nixos.org/nixos"><img src="https://nixos.org/logo/nixos-hires.png" width="500px" alt="NixOS logo" /></a>
</p>

<p align="center">
  <a href="https://www.codetriage.com/nixos/nixpkgs"><img src="https://www.codetriage.com/nixos/nixpkgs/badges/users.svg" alt="Code Triagers badge" /></a>
  <a href="https://opencollective.com/nixos"><img src="https://opencollective.com/nixos/tiers/supporter/badge.svg?label=Supporter&color=brightgreen" alt="Open Collective supporters" /></a>
</p>

[Nixpkgs](https://github.com/nixos/nixpkgs) is a collection of over
40,000 software packages that can be installed with the
[Nix](https://nixos.org/nix/) package manager. It also implements
[NixOS](https://nixos.org/nixos/), a purely-functional Linux distribution.

# Manuals

* [NixOS Manual](https://nixos.org/nixos/manual) - how to install, configure, and maintain a purely-functional Linux distribution
* [Nixpkgs Manual](https://nixos.org/nixpkgs/manual/) - contributing to Nixpkgs and using programming-language-specific Nix expressions
* [Nix Package Manager Manual](https://nixos.org/nix/manual) - how to write Nix expressions (programs), and how to use Nix command line tools

# Community

* [Discourse Forum](https://discourse.nixos.org/)
* [IRC - #nixos on freenode.net](irc://irc.freenode.net/#nixos)
* [NixOS Weekly](https://weekly.nixos.org/)
* [Community-maintained wiki](https://nixos.wiki/)
* [Community-maintained list of ways to get in touch](https://nixos.wiki/wiki/Get_In_Touch#Chat) (Discord, Matrix, Telegram, other IRC channels, etc.)

# Other Project Repositories

The sources of all official Nix-related projects are in the [NixOS
organization on GitHub](https://github.com/NixOS/). Here are some of
the main ones:

* [Nix](https://github.com/NixOS/nix) - the purely functional package manager
* [NixOps](https://github.com/NixOS/nixops) - the tool to remotely deploy NixOS machines
* [Nix RFCs](https://github.com/NixOS/rfcs) - the formal process for making substantial changes to the community
* [NixOS homepage](https://github.com/NixOS/nixos-homepage) - the [NixOS.org](https://nixos.org) website
* [hydra](https://github.com/NixOS/hydra) - our continuous integration system
* [NixOS Artwork](https://github.com/NixOS/nixos-artwork) - NixOS artwork

# Continuous Integration and Distribution

Nixpkgs and NixOS are built and tested by our continuous integration
system, [Hydra](https://hydra.nixos.org/).

* [Continuous package builds for unstable/master](https://hydra.nixos.org/jobset/nixos/trunk-combined)
* [Continuous package builds for the NixOS 20.03 release](https://hydra.nixos.org/jobset/nixos/release-20.03)
* [Tests for unstable/master](https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents)
* [Tests for the NixOS 20.03 release](https://hydra.nixos.org/job/nixos/release-20.03/tested#tabs-constituents)

Artifacts successfully built with Hydra are published to cache at
https://cache.nixos.org/. When successful build and test criteria are
met, the Nixpkgs expressions are distributed via [Nix
channels](https://nixos.org/nix/manual/#sec-channels).

# Contributing

Nixpkgs is among the most active projects on GitHub. While thousands
of open issues and pull requests might seem a lot at first, it helps
consider it in the context of the scope of the project. Nixpkgs
describes how to build over 40,000 pieces of software and implements a
Linux distribution. The [GitHub Insights](https://github.com/NixOS/nixpkgs/pulse)
page gives a sense of the project activity.

Community contributions are always welcome through GitHub Issues and
Pull Requests. When pull requests are made, our tooling automation bot,
[OfBorg](https://github.com/NixOS/ofborg) will perform various checks
to help ensure expression quality.

The *Nixpkgs maintainers* are people who have assigned themselves to
maintain specific individual packages. We encourage people who care
about a package to assign themselves as a maintainer. When a pull
request is made against a package, OfBorg will notify the appropriate
maintainer(s). The *Nixpkgs committers* are people who have been given
permission to merge.

Most contributions are based on and merged into these branches:

* `master` is the main branch where all small contributions go
* `staging` is branched from master, changes that have a big impact on
  Hydra builds go to this branch
* `staging-next` is branched from staging and only fixes to stabilize
  and security fixes with a big impact on Hydra builds should be
  contributed to this branch. This branch is merged into master when
  deemed of sufficiently high quality

For more information about contributing to the project, please visit
the [contributing page](https://github.com/NixOS/nixpkgs/blob/master/.github/CONTRIBUTING.md).

# Donations

The infrastructure for NixOS and related projects is maintained by a
nonprofit organization, the [NixOS
Foundation](https://nixos.org/nixos/foundation.html). To ensure the
continuity and expansion of the NixOS infrastructure, we are looking
for donations to our organization.

You can donate to the NixOS foundation by using Open Collective:

<a href="https://opencollective.com/nixos#support"><img src="https://opencollective.com/nixos/tiers/supporter.svg?width=890" /></a>

# License

Nixpkgs is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by Nixpkgs,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included in Nixpkgs, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.
