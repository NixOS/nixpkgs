<br>
<p align="center">
  <img src="./media/botnix_simple_narrow_bw_1000w.png" width="50%" alt="Botnix logo" />
</p>

<p align="center" width="100%">  
  <a alt="Botnix Build"
    href="https://github.com/nervosys/Botnix/actions/workflows/test_build.yml">
    <img src="https://github.com/nervosys/Botnix/actions/workflows/test_build.yml/badge.svg">
  </a>
</p>

<h1 align="center">The operating system for autonomous systems</h1>

## Announcements

* _Welcome to Botnix!_
* We are working on our first major release: `Botnix 1.0 Torbjörn` (pronounced *torr-beyourn*, meaning "Bear of Thor") &#128059;
* `Botnix` works out-of-the-box using standard `NixOS` conventions and is currently in active development.
* Join us in building the future of robot operating systems! See the [Contributing](#contributing) section. We welcome contributions from all.

## Vision

> "The first era of operating systems (OSes) was defined by the punchcard, while the second, third, and fourth were defined by the keyboard, mouse, and touchscreen, respectively. With Botnix, we begin a fifth era defined by artificial intelligence (AI) and predictive programs for powerful and diverse user and computer interaction. The rise of the hybrid computer architecuture and modern compiler infrastructure together provide the ideal foundation to forge a new era of the AI-OS." [-Dr. Adam Erickson, 2024](#)

## Introduction

`Botnix` is the first operating system (OS) and Linux distribution for multi-agent and -domain *autonomous systems*, *intelligent robotic systems*, or [*embodiment*](https://arxiv.org/abs/2103.04918) as it is known in the artificial intelligence (AI) research community. `Botnix` stands for "Robotics Linux". **Our goal is to create the ideal OS for intelligent robotic systems in-the-wild**, built on the widely deployed and field-tested Linux kernel and the powerful Nix [software deployment model](https://edolstra.github.io/pubs/phd-thesis.pdf). `Botnix` provides the `Botpkgs` or "Robotics Packages" software repository, a domain-specific subset of the 80,000+ packages found in the [Nixpkgs](https://github.com/nixos/nixpkgs/) repository. `Botnix` aims to be a single-purpose, battle-hardened variant of `NixOS` using the same declarative design; a production-grade OS that supports state-of-the-art research in AI for robotics.

`Botnix` is designed with the future in mind. As a community of [Builders](https://a16z.com/its-time-to-build/), we aim to accelerate the development and deployment of AI for robotics. The `Botnix` software and community are free and open-source. We welcome contributions from all individuals, organizations, and industries. *We are grateful for your support!*

## Getting Started

Coming soon.

### Operational Modes

The `Botnix` OS will be available in seven different operational modes or flavours:

* Agent
* Orchestrator
* Knowledgebase
* Monitor
* Simulator (via [AutonomySim](https://github.com/nervosys/AutonomySim))
* Trainer
* Developer

Each of the modes involves specialized configurations that reflect their use cases within the realm of autonomous systems.

At present, we are focusing on the `Agent` mode.

## Documentation

Below you can find documentation for Robotics Linux (`Botnix`), Robotics Packages (`Botpkgs`), and `AutonomySim` from [Nervosys](https://nervosys.ai/), as well as related [NixOS Foundation](https://nixos.org/community/index.html) projects.

### Botnix and Botpkgs

Coming soon.

* [Botnix and Botpkgs Manual](#documentation) - To be hosted here: https://nervosys.github.io/Botnix

### AutonomySim

`Botnix` is only half of the equation in developing and deploying autonomous systems for the real world. `Botnix` is designed to be co-developed and integrated with [`AutonomySim`](https://github.com/nervosys/AutonomySim/), the simulation engine for autonomous systems, for which documentation can be found below.

* [AutonomySim](https://nervosys.github.io/AutonomySim) - The simulation engine for autonomous systems

### NixOS, Nixpkgs, Nix

* [NixOS Manual](https://nixos.org/nixos/manual/) - how to install, configure, and maintain a purely-functional Linux distribution
* [Nixpkgs Manual](https://nixos.org/nixpkgs/manual/) - contributing to Nixpkgs and using programming-language-specific Nix expressions
* [Nix Manual](https://nixos.org/nix/manual/) - how to write Nix expressions (programs), and how to use Nix command line tools

# Community

* [Discourse Forum](https://discourse.nixos.org/)
* [Matrix Chat](https://matrix.to/#/#community:nixos.org)
* [NixOS Weekly](https://weekly.nixos.org/)
* [Community-maintained wiki](https://nixos.wiki/)
* [Community-maintained list of ways to get in touch](https://nixos.wiki/wiki/Get_In_Touch#Chat) (Discord, Telegram, IRC, etc.)

# Other Project Repositories

The sources of all official Nix-related projects are in the [NixOS
organization on GitHub](https://github.com/NixOS/). Here are some of
the main ones:

* [Nix](https://github.com/NixOS/nix) - the purely functional package manager
* [NixOps](https://github.com/NixOS/nixops) - the tool to remotely deploy NixOS machines
* [nixos-hardware](https://github.com/NixOS/nixos-hardware) - NixOS profiles to optimize settings for different hardware
* [Nix RFCs](https://github.com/NixOS/rfcs) - the formal process for making substantial changes to the community
* [NixOS homepage](https://github.com/NixOS/nixos-homepage) - the [NixOS.org](https://nixos.org) website
* [hydra](https://github.com/NixOS/hydra) - our continuous integration system
* [NixOS Artwork](https://github.com/NixOS/nixos-artwork) - NixOS artwork

# Continuous Integration and Distribution

Nixpkgs and NixOS are built and tested by our continuous integration
system, [Hydra](https://hydra.nixos.org/).

* [Continuous package builds for unstable/master](https://hydra.nixos.org/jobset/nixos/trunk-combined)
* [Continuous package builds for NixOS 23.11](https://hydra.nixos.org/jobset/nixos/release-23.11)
* [Tests for unstable/master](https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents)
* [Tests for the NixOS 23.11 release](https://hydra.nixos.org/job/nixos/release-23.11/tested#tabs-constituents)

Artifacts successfully built with Hydra are published to cache at https://cache.nixos.org/.
When successful build and test criteria are met, the Nixpkgs expressions are distributed via [Nix channels](https://nixos.org/manual/nix/stable/package-management/channels.html).

# Contributing

Nixpkgs is among the most active projects on GitHub. While thousands
of open issues and pull requests might seem a lot at first, it helps
consider it in the context of the scope of the project. Nixpkgs
describes how to build tens of thousands of pieces of software and implements a
Linux distribution. The [GitHub Insights](https://github.com/NixOS/nixpkgs/pulse)
page gives a sense of the project activity.

Community contributions are always welcome through GitHub Issues and
Pull Requests.

For more information about contributing to the project, please visit
the [contributing page](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md).

# Donations

The infrastructure for NixOS and related projects is maintained by a
nonprofit organization, the [NixOS
Foundation](https://nixos.org/nixos/foundation.html). To ensure the
continuity and expansion of the NixOS infrastructure, we are looking
for donations to our organization.

You can donate to the NixOS foundation through [SEPA bank
transfers](https://nixos.org/donate.html) or by using Open Collective:

<a href="https://opencollective.com/nixos#support"><img src="https://opencollective.com/nixos/tiers/supporter.svg?width=890" /></a>

# License

Nixpkgs is licensed under the [MIT License](COPYING).

Note: MIT license does not apply to the packages built by Nixpkgs,
merely to the files in this repository (the Nix expressions, build
scripts, NixOS modules, etc.). It also might not apply to patches
included in Nixpkgs, which may be derivative works of the packages to
which they apply. The aforementioned artifacts are all covered by the
licenses of the respective packages.
