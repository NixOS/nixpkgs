<p align="center">
  <a href="https://nixos.org">
    <picture>
      <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/NixOS/nixos-homepage/main/public/logo/nixos-hires.png">
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos-white.png">
      <img src="https://raw.githubusercontent.com/NixOS/nixos-homepage/main/public/logo/nixos-hires.png" width="500px" alt="NixOS logo">
    </picture>
  </a>
</p>

<p align="center">
  <a href="CONTRIBUTING.md"><img src="https://img.shields.io/github/contributors-anon/NixOS/nixpkgs" alt="Contributors badge" /></a>
  <a href="https://opencollective.com/nixos"><img src="https://opencollective.com/nixos/tiers/supporter/badge.svg?label=supporters&color=brightgreen" alt="Open Collective supporters" /></a>
</p>

[Nixpkgs](https://github.com/nixos/nixpkgs) is a collection of over
100,000 software packages that can be installed with the
[Nix](https://nixos.org/nix/) package manager. It also implements
[NixOS](https://nixos.org/nixos/), a purely-functional Linux distribution.

## 🚀 Quick Start

**Step 1: Install Nix**

To install the Nix package manager, run:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

_This script works on most Linux distributions and macOS._

**Step 2: Install a Package**

For example, to install `hello`, run:

```bash
nix-env -iA nixpkgs.hello
```

**Step 3: Verify Installation**

Check your installation by running:

```bash
hello
```

You should see:

```
Hello, world!
```

**Step 4: Remove a Package**

To uninstall, use:

```bash
nix-env -e hello
```

## 🛠️ Troubleshooting

### Issue 1: Permission Errors During Installation
- **Problem**: You get errors like `permission denied`.
- **Solution**: Ensure the install script runs with appropriate permissions. Run:
  ```bash
  sh <(curl -L https://nixos.org/nix/install) --daemon
  ```
  _This sets up Nix as a daemon, solving most permission issues._

### Issue 2: Command Not Found After Installation
- **Problem**: Nix commands like `nix-env` aren't found after installation.
- **Solution**: Reload your shell or source your profile:
  ```bash
  source ~/.nix-profile/etc/profile.d/nix.sh
  ```
  _This makes the Nix commands available immediately._

### Issue 3: Package Not Found
- **Problem**: You get `error: attribute ... not found` when installing a package.
- **Solution**: Check the exact package name on [search.nixos.org](https://search.nixos.org/packages). Ensure you're using the correct attribute path (e.g., `nixpkgs.hello`).

### Issue 4: Updating Packages
- **Problem**: Your packages aren’t updating or you’re seeing old versions.
- **Solution**: Update your channels and packages by running:
  ```bash
  nix-channel --update
  nix-env -u '*'
  ```
  _This updates all installed packages._

# Manuals

* [NixOS Manual](https://nixos.org/nixos/manual) - how to install, configure, and maintain a purely-functional Linux distribution
* [Nixpkgs Manual](https://nixos.org/nixpkgs/manual/) - contributing to Nixpkgs and using programming-language-specific Nix expressions
* [Nix Package Manager Manual](https://nixos.org/nix/manual) - how to write Nix expressions (programs), and how to use Nix command line tools

# Community

* [Discourse Forum](https://discourse.nixos.org/)
* [Matrix Chat](https://matrix.to/#/#community:nixos.org)
* [NixOS Weekly](https://weekly.nixos.org/)
* [Official wiki](https://wiki.nixos.org/)
* [Community-maintained list of ways to get in touch](https://wiki.nixos.org/wiki/Get_In_Touch#Chat) (Discord, Telegram, IRC, etc.)

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
* [Continuous package builds for the NixOS 24.11 release](https://hydra.nixos.org/jobset/nixos/release-24.11)
* [Tests for unstable/master](https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents)
* [Tests for the NixOS 24.11 release](https://hydra.nixos.org/job/nixos/release-24.11/tested#tabs-constituents)

Artifacts successfully built with Hydra are published to cache at
https://cache.nixos.org/. When successful build and test criteria are
met, the Nixpkgs expressions are distributed via [Nix
channels](https://nix.dev/manual/nix/stable/command-ref/nix-channel.html).

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
the [contributing page](CONTRIBUTING.md).

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
