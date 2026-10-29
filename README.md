# nixpkgs-arkhe

Fork do [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs) que hospeda o
empacotamento dos crates Rust Arkhe: flake, overlay e módulos NixOS.
Os arquivos do projeto estão em [`arkhe/`](arkhe/). A integração oficial no
Nixpkgs está sendo preparada; ainda não há PR aberto nem pacote aceito upstream.

## Usar os pacotes Arkhe

Execute no Linux ou WSL com Nix e os recursos `nix-command flakes` habilitados:

```sh
nix build 'github:rafael-arkhe/nixpkgs-arkhe?dir=arkhe#arkhe-verify-cli'
nix run 'github:rafael-arkhe/nixpkgs-arkhe?dir=arkhe#arkhe-verify-cli' -- --help
nix build 'github:rafael-arkhe/nixpkgs-arkhe?dir=arkhe#arkhe-verify-wasm'
nix build 'github:rafael-arkhe/nixpkgs-arkhe?dir=arkhe#arkhe-sdd-parser'
```

O parâmetro `dir=arkhe` seleciona o flake Arkhe. O flake na raiz continua sendo
o do Nixpkgs. Para fixar também esta integração, use uma revisão do repositório:
`github:rafael-arkhe/nixpkgs-arkhe/<commit>?dir=arkhe`.

Em um checkout local:

```sh
cd arkhe
nix flake check --no-update-lock-file --print-build-logs
bash scripts/check-reproducibility.sh arkhe-verify-cli arkhe-verify-wasm arkhe-sdd-parser
```

## Validação observada em 29/10/2026

| Escopo | Resultado |
|---|---|
| Overlay com Rust 1.96.0 fixado | 24 checks passaram em x86_64-linux, Ubuntu WSL, Nix 2.35.4 |
| Verificador, WASM e SDD | Reconstruções idênticas na mesma máquina; hashes e logs versionados |
| Variante CA do verificador | Construída; endereçamento por conteúdo confirmado |
| Receita proposta ao Nixpkgs | Build, golden vectors, teste BLAKE3 e `nix-build --check` passaram com o Rust 1.99.0 padrão da base upstream |
| Outra máquina/VM na rodada atual | Pendente; os registros históricos de VM usam outra revisão/toolchain |
| aarch64 e Darwin | Não construídos nesta rodada |

Os resultados locais não representam aprovação ou sucesso do CI no GitHub.
A variante CA é opcional e exige `ca-derivations`; os builds normais não exigem
esse recurso experimental.

## Documentação e contribuição upstream

- [Pacotes, overlay, módulos e comandos de verificação](arkhe/README.md).
- [Evidências do overlay com Rust 1.96.0](arkhe/docs/validation/rust-1.96.0/results.json).
- [Proposta de `arkhe-verify` ao NixOS/nixpkgs](arkhe/nixpkgs/README.md).
- [Evidências da receita upstream com Rust 1.99.0](arkhe/docs/validation/nixpkgs-upstream/results.json).
- [Reprodutibilidade e limites das verificações](arkhe/docs/reproducibility.md).

A revisão de fontes
[`228da8e803e9f81041066e3a3a50f61e6ff4201c`](https://github.com/rafael-arkhe/nixpkgs-arkhe/tree/228da8e803e9f81041066e3a3a50f61e6ff4201c)
contém somente o workspace Arkhe na raiz, com Cargo.lock, sem a árvore do
Nixpkgs. Ela é a fonte pública imutável da proposta inicial, mantida por
`rafael-arkhe`. WASM, SDD e os demais pacotes permanecem no overlay.

## Referência do upstream Nixpkgs

O conteúdo abaixo é o README original da base deste fork.

<p align="center">
  <a href="https://nixos.org">
    <picture>
      <source media="(prefers-color-scheme: light)" srcset="https://brand.nixos.org/logos/nixos-logo-default-gradient-black-regular-horizontal-minimal.svg">
      <source media="(prefers-color-scheme: dark)" srcset="https://brand.nixos.org/logos/nixos-logo-default-gradient-white-regular-horizontal-minimal.svg">
      <img src="https://brand.nixos.org/logos/nixos-logo-default-gradient-black-regular-horizontal-minimal.svg" width="500px" alt="NixOS logo">
    </picture>
  </a>
</p>

<p align="center">
  <a href="CONTRIBUTING.md"><img src="https://img.shields.io/github/contributors-anon/NixOS/nixpkgs" alt="Contributors badge" /></a>
  <a href="https://opencollective.com/nixos"><img src="https://opencollective.com/nixos/tiers/supporter/badge.svg?label=supporters&color=brightgreen" alt="Open Collective supporters" /></a>
</p>

[Nixpkgs](https://github.com/nixos/nixpkgs) is a collection of over 140,000 software packages that can be installed with the [Nix](https://nixos.org/nix/) package manager.
It also implements [NixOS](https://nixos.org/nixos/), a purely-functional Linux distribution.

# Manuals

* [NixOS Manual](https://nixos.org/nixos/manual) - how to install, configure, and maintain a purely-functional Linux distribution
* [Nixpkgs Manual](https://nixos.org/nixpkgs/manual/) - contributing to Nixpkgs and using programming-language-specific Nix expressions
* [Nix Package Manager Manual](https://nixos.org/nix/manual) - how to write Nix expressions (programs), and how to use Nix command line tools

# Community

* [Discourse Forum](https://discourse.nixos.org/)
* [Matrix Chat](https://matrix.to/#/#space:nixos.org)
* [Official wiki](https://wiki.nixos.org/)
* [Community-maintained list of ways to get in touch](https://wiki.nixos.org/wiki/Get_In_Touch#Chat) (Discord, Telegram, IRC, etc.)

# Other Project Repositories

The sources of all official Nix-related projects are in the [NixOS organization on GitHub](https://github.com/NixOS/).
Here are some of the main ones:

* [Nix](https://github.com/NixOS/nix) - the purely functional package manager
* [NixOps](https://github.com/NixOS/nixops) - the tool to remotely deploy NixOS machines
* [nixos-hardware](https://github.com/NixOS/nixos-hardware) - NixOS profiles to optimize settings for different hardware
* [Nix RFCs](https://github.com/NixOS/rfcs) - the formal process for making substantial changes to the community
* [NixOS homepage](https://github.com/NixOS/nixos-homepage) - the [NixOS.org](https://nixos.org) website
* [hydra](https://github.com/NixOS/hydra) - our continuous integration system
* [NixOS Branding](https://github.com/NixOS/branding) - NixOS branding

# Continuous Integration and Distribution

Nixpkgs and NixOS are built and tested by our continuous integration system, [Hydra](https://hydra.nixos.org/).

* [Continuous package builds for unstable/master](https://hydra.nixos.org/jobset/nixos/trunk-combined)
* [Continuous package builds for the NixOS 26.05 release](https://hydra.nixos.org/jobset/nixos/release-26.05)
* [Tests for unstable/master](https://hydra.nixos.org/job/nixos/trunk-combined/tested#tabs-constituents)
* [Tests for the NixOS 26.05 release](https://hydra.nixos.org/job/nixos/release-26.05/tested#tabs-constituents)

Artifacts successfully built with Hydra are published to cache at https://cache.nixos.org/.
When successful build and test criteria are met, the Nixpkgs expressions are distributed via [Nix channels](https://nix.dev/manual/nix/stable/command-ref/nix-channel.html).

# Contributing

Nixpkgs is among the most active projects on GitHub.
While thousands of open issues and pull requests might seem like a lot at first, it helps to consider it in the context of the scope of the project.
Nixpkgs describes how to build tens of thousands of pieces of software and implements a Linux distribution.
The [GitHub Insights](https://github.com/NixOS/nixpkgs/pulse) page gives a sense of the project activity.

Community contributions are always welcome through GitHub Issues and Pull Requests.

For more information about contributing to the project, please visit the [contributing page](CONTRIBUTING.md).

# Donations

The infrastructure for NixOS and related projects is maintained by a nonprofit organization, the [NixOS Foundation](https://nixos.org/nixos/foundation.html).
To ensure the continuity and expansion of the NixOS infrastructure, we are looking for donations to our organization.

You can donate to the NixOS Foundation through [SEPA bank transfers](https://nixos.org/donate.html) or by using Open Collective:

<a href="https://opencollective.com/nixos#support"><img src="https://opencollective.com/nixos/tiers/supporter.svg?width=890" /></a>

# License

Nixpkgs is licensed under the [MIT License](COPYING).

> [!Note]
> MIT license does not apply to the packages built by Nixpkgs, merely to the files in this repository (the Nix expressions, build scripts, NixOS modules, etc.).
It also might not apply to patches included in Nixpkgs, which may be derivative works of the packages to which they apply.
The aforementioned artifacts are all covered by the licenses of the respective packages.

## Arkhe packages

The Arkhe packaging layer is in [arkhe/](arkhe/README.md). Build the offline verifier with `nix build ./arkhe#arkhe-verify`. For flake consumers use `github:rafael-arkhe/nixpkgs-arkhe?dir=arkhe`. The Nixpkgs interface at this repository root is preserved.
