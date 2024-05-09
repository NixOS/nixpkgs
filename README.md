<br>
<p align="center">
  <img src="./media/images/botnix_simple_narrow_bw_1000w.png" width="50%" alt="Botnix logo" />
</p>

<!---
<p align="center" width="100%">  
  <a alt="Botnix Build"
    href="https://github.com/nervosys/Botnix/actions/workflows/test_build.yml">
    <img src="https://github.com/nervosys/Botnix/actions/workflows/test_build.yml/badge.svg">
  </a>
</p>
--->

<h1 align="center">The operating system for autonomous systems</h1>

## Announcements

* _Welcome to Botnix!_
* We are working on our first major release: `Botnix 1.0 Torbjörn` (pronounced *torr-beyourn*, meaning "Bear of Thor") &#128059;
* `Botnix` works out-of-the-box using standard `NixOS` conventions and is currently in active development.
* Join us in building the future of robot operating systems! See the [Contributing](#contributing) section. We welcome contributions from all.

## Vision

> "The first era of operating systems (OSes) was defined by the punchcard, while the second, third, and fourth were defined by the keyboard, mouse, and touchscreen, respectively. With Botnix, we begin a fifth era defined by artificial intelligence (AI) and predictive programs for powerful and diverse user and computer interaction. The rise of the hybrid computer architecuture and modern compiler infrastructure together provide the ideal foundation to forge a new era of the AI-OS." [-Dr. Adam Erickson, 2024](#)

## Introduction

`Botnix` is the first operating system (OS) and Linux distribution for multi-agent and -domain *autonomous systems*, *intelligent robotic systems*, or [*embodiment*](https://arxiv.org/abs/2103.04918) as it is known in the artificial intelligence (AI) research community. `Botnix` stands for "Robot Linux" or "Robotics Linux". **Our goal is to create the ideal OS for intelligent robotic systems in-the-wild**, built on the widely deployed and field-tested Linux kernel and the powerful Nix [software deployment model](https://edolstra.github.io/pubs/phd-thesis.pdf). `Botnix` provides the `Botpkgs` or "Bot packages" software repository, a domain-specific subset of the 80,000+ packages found in the [Nixpkgs](https://github.com/nixos/nixpkgs/) repository. `Botnix` is a single-purpose, battle-hardened variant of `NixOS` using the same declarative design. It is a production-grade OS that supports state-of-the-art research in AI for robotics.

`Botnix` is designed with the future in mind. As a community of [Builders](https://a16z.com/its-time-to-build/), we aim to accelerate the development and deployment of AI for robotics. The `Botnix` software and community are free and open-source. We welcome contributions from all individuals, organizations, and industries. *We are grateful for your support!*

## Getting Started

Coming soon.

### Operational Modes

The `Botnix` OS will be available in seven different flavors or operational modes:

1. Agent
2. Orchestrator
3. Knowledgebase (or vector database)
4. Monitor
5. Simulator (via [AutonomySim](https://github.com/nervosys/AutonomySim))
6. Trainer
7. Developer

Each of the modes involves specialized configurations that reflect their use cases within the realm of autonomous systems.

At present, we are focusing on the `Agent` mode.

## Documentation

Below you can find documentation for Robotics Linux (`Botnix`), Robotics Packages (`Botpkgs`), and `AutonomySim` from [Nervosys](https://nervosys.ai/), as well as related [NixOS Foundation](https://nixos.org/community/index.html) projects.

### Botnix and Botpkgs

* [Botnix and Botpkgs Manual](https://nervosys.github.io/Botnix/) - The operating system for autonomous systems

### AutonomySim

`Botnix` is only half of the equation in developing and deploying autonomous systems for the real world. `Botnix` is designed to be co-developed and integrated with [`AutonomySim`](https://github.com/nervosys/AutonomySim/), the simulation engine for autonomous systems, for which documentation can be found below.

* [AutonomySim](https://nervosys.github.io/AutonomySim/) - The simulation engine for autonomous systems

### NixOS, Nixpkgs, Nix

* [NixOS Manual](https://nixos.org/nixos/manual/) - how to install, configure, and maintain a purely-functional Linux distribution
* [Nixpkgs Manual](https://nixos.org/nixpkgs/manual/) - contributing to Nixpkgs and using programming-language-specific Nix expressions
* [Nix Manual](https://nixos.org/nix/manual/) - how to write Nix expressions (programs), and how to use Nix command line tools

## Why Botnix?

Like many of you, we are thrilled about recent advances in open-source AI and robotics, but have run across some challenges along the way:

1. The [Robot Operating System (ROS)](https://www.ros.org/) is not an OS at all, but rather, a collection of software packages. Getting ROS installed and configured for a particular OS can be a hassle. This increases the time needed to get up and running. ROS also provides no little to no tools to manage robot sofware deployment, requiring third-party tools with additional complexity and constraints.
2. [RoboStack](https://robostack.github.io/) is a step in the right direction by using the Conda package manager for dependency management in C/C++ and Python projects. Unfortunately, it is an incomplete solution that introduces yet another package manager to be managed.
3. Configuring a machine for AI development and/or deployment can still be a significant burden. Common challenges include installing mutually compatible graphics drivers, CUDA libraries, and deep learning frameworks. An entirely separate package manager such as [conda](https://docs.conda.io/en/latest/) or [micromamba](https://mamba.readthedocs.io/en/latest/) is often used for dependecy management. If we begin with the 'right' package manager (e.g., `Nix`), all of this added complexity becomes unnecessary.
4. Popular flight control system (FCS) software (e.g., ArduPilot, PX4, BetaFlight) projects remain focused on microcontroller-based real-time OSes for unmanned aircraft systems (UAS). ArduPilot and PX4 are based on [ChibiOS](https://www.chibios.org/dokuwiki/doku.php) and Apache [NuttX](https://nuttx.apache.org/), respectively, two hard real-time OSes designed for microcontrollers. Because of this, ArduPilot- and PX4-based systems still must rely on separate Linux companion computers for the heavy lifting. *This is not the way*.
5. [ROS-O](https://github.com/ros-o/ros-o/), or `ROS One`, aims to make it easier to deploy `ROS` by providing patches for popular operating systems and package managers. `ROS-O` is not an operating system and is limited to ROS deployment, making it a piecemeal solution.
6. [Debian](https://www.debian.org/) 12 ("bookworm") is our favorite release to date, but it remains a traditional Linux OS poorly suited to our use case.
7. While [Ubuntu](https://ubuntu.com/robotics/) is the most popular Linux OS, and Ubuntu Core is intended for robotics among other things, it has all of the limitations of Debian plus proprietary Snaps, a closed source, and a high price. *Robotics should be open to everyone*.
8. [The Yocto Project](https://www.yoctoproject.org/) and the related [OpenEmbedded layers for ROS](https://github.com/ros/meta-ros) is a major step in the right direction, but OSes must be hand-crafted and lack the powerful Nix system for configuring and deploying robotic systems, which we call RoboDevSecOps.
9. [OSTree](https://ostreedev.github.io/ostree/) is yet another solution designed without robotics in mind that must be arduously adapted to our use case.
10. [GNU Guix](https://guix.gnu.org/) is the next best thing to `NixOS` with some theoretical advantages. In practice though, we found `Guix` to be less reliable and supported than `NixOS`. While the potential there, we were more comfortable moving forward with the large and rapidly growing `Nix` community.
11. We love unikernels or Library operating systems (libOSes), but they are often slow and painful to deploy using common tools. Thankfully `Nix` can automate the process. That's right, you can use `Nix` to [build and deploy unikernels](https://tarides.com/blog/2022-12-14-hillingar-mirageos-unikernels-on-nixos/). The two systems are not mutually exclusive.

After careful consideration, we decided that the focus of `Botnix` substantially differs from that of `NixOS` and other communities, given our sole focus on AI for robotics. There are numerous drivers and applications that are relevant to a general-purpose OS, but not to our use case. Removing this overhead allows us to be more efficient. We want to accelerate robotics, and to do so, we must be focused.

Last, we felt that the Apache 2.0 license might be better suited to commercial adoption.

## Related Projects

All official `NixOS` project sources are maintained at the [NixOS organization](https://github.com/NixOS/) on GitHub:

* [Nix](https://github.com/NixOS/nix/) - a purely functional package manager
* [NixOps](https://github.com/NixOS/nixops/) - a tool to remotely deploy NixOS machines
* [NixOS hardware](https://github.com/NixOS/nixos-hardware/) - NixOS profiles to optimize settings for different hardware
* [Nix RFCs](https://github.com/NixOS/rfcs/) - the formal process for making substantial changes to the community
* [NixOS homepage](https://github.com/NixOS/nixos-homepage/) - the [NixOS.org](https://nixos.org/) website
* [NixOS Artwork](https://github.com/NixOS/nixos-artwork/) - the NixOS artwork
* [Hydra](https://github.com/NixOS/hydra/) - the NixOS continuous integration (CI) system

## Continuous Integration and Deployment (CI/CD)

`Botnix` and `Botpkgs` are built and tested using [GitHub Actions](https://docs.github.com/en/actions).

`Nixpkgs` and `NixOS` are built and tested using the `Nix`-based [Hydra](https://hydra.nixos.org/) CI/CD system.

* [Continuous package builds for unstable/master](https://hydra.nixos.org/jobset/nixos/trunk-combined)
* [Continuous package builds for the NixOS 23.11 release](https://hydra.nixos.org/jobset/nixos/release-23.11)
* [Tests for unstable/master](https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents)
* [Tests for the NixOS 23.11 release](https://hydra.nixos.org/job/nixos/release-23.11/tested#tabs-constituents)

Artifacts successfully built with Hydra are published to the `Nixpkgs` [https://cache.nixos.org/](cache).
When building and testing succeed, the `Nixpkgs` expressions are distributed via [Nix channels](https://nixos.org/manual/nix/stable/package-management/channels.html).

## Join the Community

For updates or answers to your questions, join our GitHub Discussion group [here](https://github.com/nervosys/Botnix/discussions) or our Discord channel [here](https://discord.gg/FA4UjaB7/).

For information on becoming a contributor, see the following section.

## Contributing

`Botnix` implements a Linux distribution for AI and robotics based on `NixOS`, `Nixpkgs`, and `Nix`. In essence, `Botnix` and `Botpkgs` represent a paired down, domain-specific, security hardened, real-time variant of `NixOS` and `Nixpkgs` with first class support for artificial intelligence (AI) and popular robotics workflows.

Community contributions are *strongly encouraged* via GitHub Issues and Pull Requests. For more information about contributing to the project, please visit the [contributing page](https://github.com/nervosys/botnix/blob/master/CONTRIBUTING.md).

The [GitHub Insights](https://github.com/nervosys/botnix/pulse/) page gives a sense of the project activity.

### Project Structure

Coming soon.

## References

A manuscript on the design and implementation of `Botnix` is forthcoming.

## Roadmap

- [x] Remove bloat not application to intelligent robotic systems, focus on a single desktop environment (Gnome)
- [ ] Create `Botpkgs` reduced to domain-specific security-audited packages
- [ ] Create OS flavours with sane defaults: Agent, Orchestrator, Knowledgebase, Monitor, Simulator, Trainer, Developer
- [ ] Add pinned libraries, APIs, tools for artificial intelligence (AI) in robotics
  - [ ] C++ (C++20: gcc-12, clang-17)
  - [ ] Rust 1.73.0, Ferrocene
  - [ ] Python 3.12
  - [ ] Modular Mojo 1.0
  - [ ] Julia 1.9.3
  - [ ] NVIDIA CUDA 11.8, CuDNN 8.6.0, TensorRT 8.5.3
  - [ ] PyTorch 2.1.0 (see CUDA)
  - [ ] Tensorflow 2.14 (see CUDA)
  - [ ] Reinforcement learning: OpenAI Five, Dactyl, Autocurricula
  - [ ] Agent environments: OpenAI Gym, NVIDIA IsaacGym, Meta HabitatLab, [TBA: AutonomyGym](https://github.com/nervosys/AutonomyGym/)
  - [ ] Large language models (LLMs): Meta Llama2, Llama2 Code, Eureka/GPT4, LoRA,
  - [ ] Text-language: OpenAI CLIP,
  - [ ] Speech recognition: OpenAI Whisper
  - [ ] Hybrid neural networks: see differentiable physics, programming languages
  - [ ] Probabilistic programming: Pyro
  - [ ] Add packages for robotics: ROS2, Gazebo, Meta HomeRobot, [AutonomySim](https://github.com/nervosys/AutonomySim/)
  - [ ] Add packages for flight control: PX4, ArduPilot, MAVLink, BetaFlight, OpenPilot/LibrePilot, dRehmFlight, Flightmare
  - [ ] Add packages for self-driving car control: openpilot, Autoware, CARLA, Vista, Aslan, OpenPodcar/ROS
- [ ] Add packages for physics engines (embodiment) and game engines (self-simulation)
  - [ ] Add packages for game engines: Unreal Engine 5, Unity, NVIDIA IsaacSim, Meta HabitatSim
  - [ ] Add packages for physics engines: PhysX, Bullet, MuJoCo, DART, Drake, Havok, ODE
  - [ ] Add packages for differentiable physics: TDS, Dojo, Brax, Nimble, NVIDIA Warp
  - [ ] Add packages for flight dynamics modeling: JSBSim
- [ ] Add boilerplate interfaces for inter-modal communication
  - [ ] Add boilerplate interfaces for multi-domain robotic system communication (e.g., ROS <> PX4)
- [ ] Add hardware and software security systems
- [ ] Add robot operations or fleet management systems
- [ ] Add labeled and unlabeled datasets, autolabeling systems
  - [ ] Habitat Synthetic Scenes Dataset (HSSD)
- [ ] Add packages for security CVE notification system
- [ ] Add packages for robot penetration testing or hacking
- [ ] Add packages for fleet management or robot operations (RobOps): InOrbit, Foxglove Studio
- [ ] Add packages for monitoring and alerts: Prometheus, Apache Kafka
- [ ] Add packages for data visualization: Grafana, browser (D3, WebGL, v8/Electron)
- [ ] Update automated tests

## Sponsors

* [Nervosys](https://nervosys.ai/): *"Accelerating the development of robotic general intelligence"*

## Donations

`Botnix` is made possible by [Nervosys](https://nervosys.ai/), the Linux Foundation, NixOS Foundation, and countless contributors to related projects.

We need your support to ensure the success of `Botnix` development. Reach out to us at opensource@nervosys.ai to learn how you can support this project.

## Background

While compute and energy constraints have historically limited robotic systems to legacy real-time OSes running on underpowered microcontrollers, these constraints are rapidly vanishing with development of new low-power [processor architectures](https://riscv.org/), [domain-specific accelerators](https://dl.acm.org/doi/10.1145/3350755.3400252), [unified memory](https://arxiv.org/abs/2304.12149), and [high-speed interconnects](https://www.uciexpress.org/), as demonstrated by the [NVIDIA Grace Hopper Superchip](https://www.nvidia.com/en-us/data-center/grace-hopper-superchip/), [Apple M1 system-on-chip (SoC)](https://www.apple.com/newsroom/2020/11/apple-unleashes-m1/), and [AMD chiplet technology](https://ieeexplore.ieee.org/document/9499852). This revolution in computing is powering a new Age of Embodied Intelligence. *We aim to be the operating system (OS) of the robotics revolution*.

**Embodied AI**: `Botnix` is intended to be the first OS with native, batteries-included support for robotics and artificial intelligence (AI) at both the high- and low-level. We aim to bring the robotics and AI software ecosystems out of piecemeal, standalone packages and libraries and into a cohesive whole at the OS level. This includes boilerplate interfaces necessary to communicate between popular software systems used in different robotics domains. We further aim to provide tools for physical intuition, such as real-time internal physics engines for hybrid neurosymbolic AI inference.

**RoboDevSecOps**: `Botnix` aims to be the ideal OS for AI and robotics developer-security-operations or [RoboDevSecOps](https://about.gitlab.com/topics/devsecops/), as the safety of deployed systems is a primary consideration in AI and robotics alike. More than a package manager, the powerful [Nix system](https://nixos.org/) enables us to provide a simple, declarative, stateful, reproducible OS with native depedency isolation (think of it as built-in containers), cloud over-the-air (OTA) updates, and rollbacks. We aim to buttress this system with robust kernel-hardening, penetration testing, monitoring, and CVE notification systems.

**Inclusive Community**: Any open-source project is only as good as its community. To make our shared vision a reality, we are creating a new community of talented contributors. We strive to create a community where all individuals, organizations, and viewpoints are welcome. We default to protecting your rights. To do so, we ask that all contributors make an effort to comply with the same well-defined [Code of Conduct](./CODE_OF_CONDUCT.md). Unlike other communities, we are not here to censor your speech by a set of abtrirary, ill-defined rules. Your voice matters to us. *We want your opinions*.

## Code of Conduct

The Botnix [Code of Conduct](CODE_OF_CONDUCT.md) is based on the _Contributor Covenant version 2.1_, itself inspired by the Mozilla standards. The original unmodified covenant can be found [here](https://www.contributor-covenant.org/version/2/1/code_of_conduct.html). The changes made better reflect the core value of our organization in preserving freedom.

For answers to common questions about this code of conduct, see the [FAQ](https://www.contributor-covenant.org/faq). Translations are available [here](https://www.contributor-covenant.org/translations).

Contact us through [GitHub Discussions](https://github.com/nervosys/Botnix/discussions) with any additional questions or comments, so that we may maintain transparency in adopting community guidelines.

## License

`Botnix` is licensed under the [Apache 2.0 License](LICENSE). The software it deploys may be licensed under a variety schemes, from open- to closed-source.

Any and all sublicenses can be found [here](sublicenses/).

<p align="center">
  <br>
  <img src="./media/images/logo_block_raven_rgi_modern_blueye_xwerx_bw_1000h.png" width="50%" alt="xwerx logo">
  <br>
  <i>"Accelerating the development of robotic general intelligence"</i>
  <br>
  TM 2024 &copy; <a href="https://nervosys.ai/">Nervosys, LLC</a>
</p>
