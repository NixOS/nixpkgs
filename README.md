# Botnix OS: the Nix-based Linux distribution for robotic intelligence

The Botnix operating system (OS) is the first Linux distribution focused on *intelligent robotic systems*, also known as
*autonomous systems* or as *embodiment* in the artificial intelligence (AI) community. Botnix is an abbreviation for
("Robot Linux"). Our goal is to create the ideal OS for modern robotic systems, built atop the widely deployed and
battle-tested Linux kernel. While compute constraints historically limited robotic systems to underpowered microcontrollers
running legacy real-time OSes, these constraints are rapidly vanishing with development of new low-power processor
architectures including hardware accelerators, unified memory, and high-speed interconnects. Botnix is designed with this
future in mind. We aim to accelerate technological progress.

Botnix is first OS with native, batteries-included support for robotics and artificial intelligence (AI). In future
iterations, we hope to bring robotics and AI software into the core of the OS at both the high (user-mode) and low
(kernel-mode) levels. To make this happen, we are reaching out to the community to recruit talented contributors.
*We need your help*.

In short, [Botnix](https://github.com/nervosys/botnix/) is a purely-functional Linux distribution based on the [Nix](https://nixos.org/nix/)
package manager and a domain-specific subset of the [Nixpkgs](https://github.com/nixos/nixpkgs/) software repository.
It represents a paired down, narrowly focused subset of NixOS.

# Why Botnix?

After careful consideration, we have decided that our focus substantially differs from that of the NixOS community given our sole
focus on robotics and artificial intelligence (AI). There are numerous drivers and applications that are relevant to a
general-purpose OS, but not to our use case. Removing this overhead allows us to be more efficient and focused on our domain.

We also seek to create a new community based on the democratic values of *freedom of speech* and *freedom of affiliation* as the
embodiment of non-discrimination in 'faceless' online communities. We pledge as a community to value all contributions equally
regardless of the source, judged only by their merits. We believe that this is the only way forward as a community and as a society.

Last, we feel that the Apache 2.0 license might be better suited to commercial adoption.

# Manuals (Nix)

* [NixOS Manual](https://nixos.org/nixos/manual/) - how to install, configure, and maintain a purely-functional Linux distribution
* [Nixpkgs Manual](https://nixos.org/nixpkgs/manual/) - contributing to Nixpkgs and using programming-language-specific Nix expressions
* [Nix Manual](https://nixos.org/nix/manual/) - how to write Nix expressions (programs), and how to use Nix command line tools

# Communities (Botnix, Nix)

* [Botnix Discord](https://discord.gg/mAHUWVgM/)
* [NixOS Discourse](https://discourse.nixos.org/)
* [NixOS Weekly](https://weekly.nixos.org/)
* [NixOS community wiki](https://nixos.wiki/)
* [NixOS community contact](https://nixos.wiki/wiki/Get_In_Touch#Chat) (Discord, Telegram, IRC, etc.)

# Related Projects (Nix)

All official NixOS project sources are maintained at the [NixOS organization](https://github.com/NixOS/) on GitHub:

* [Nix](https://github.com/NixOS/nix/) - a purely functional package manager
* [NixOps](https://github.com/NixOS/nixops/) - a tool to remotely deploy NixOS machines
* [nixos-hardware](https://github.com/NixOS/nixos-hardware/) - NixOS profiles to optimize settings for different hardware
* [Nix RFCs](https://github.com/NixOS/rfcs/) - the formal process for making substantial changes to the community
* [NixOS homepage](https://github.com/NixOS/nixos-homepage/) - the [NixOS.org](https://nixos.org/) website
* [hydra](https://github.com/NixOS/hydra/) - the NixOS continuous integration (CI) system
* [NixOS Artwork](https://github.com/NixOS/nixos-artwork/) - the NixOS artwork

# Continuous Integration and Deployment (CI/CD)

Nixpkgs and NixOS are built and tested using the Nix-based [Hydra](https://hydra.nixos.org/) CI/CD system.

* [Nixpkgs builds for unstable/master](https://hydra.nixos.org/jobset/nixos/trunk-combined)
* [Nixpkgs builds for NixOS 23.05](https://hydra.nixos.org/jobset/nixos/release-23.05)
* [Nixpkgs tests for unstable/master](https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents)
* [Nixpkgs tests for NixOS 23.05](https://hydra.nixos.org/job/nixos/release-23.05/tested#tabs-constituents)

Artifacts successfully built with Hydra are published to the Nixpkgs [https://cache.nixos.org/](cache).
When building and testing succeed, the Nixpkgs expressions are distributed via [Nix channels](https://nixos.org/manual/nix/stable/package-management/channels.html).

# Contributing

Botnix implements a Linux distribution atop a subset of NixOS, Nixpkgs, and Nix.
The [GitHub Insights](https://github.com/nervosys/botnix/pulse/) page gives a sense of the project activity.

Community contributions are *strongly encouraged* via GitHub Issues and Pull Requests.

For more information about contributing to the project, please visit the [contributing page](https://github.com/nervosys/botnix/blob/master/CONTRIBUTING.md).

# Donations

Botnix is made possible by the Linux Foundation, NixOS Foundation, [Nervosys](https://nervosys.ai/), and countless
contributors to related projects. *We need your support* to ensure the ongoing success of Botnix development.

# License

Botnix is licensed under the [Apache 2.0 License](LICENSE).
