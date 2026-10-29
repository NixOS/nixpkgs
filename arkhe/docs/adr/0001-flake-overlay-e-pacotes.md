# ADR 0001 — Flake, overlay e `buildRustPackage`

## Contexto

O monorepo Arkhe é um workspace Cargo com múltiplos membros e dependências no
`Cargo.lock` e nenhuma dependência git. O objetivo é distribuir os binários
Arkhe para Nix sem duplicar o grafo de dependências nem introduzir resolução
flutuante.

## Decisão

- Um **flake** com `nixpkgs` fixado por `flake.lock` e sistemas
  `x86_64-linux`/`aarch64-linux`.
- Um **overlay** (`overlays.default`) que expõe `pkgs.arkhe.*`.
- Um **construtor único** (`lib/mk-arkhe-package.nix`) em cima de
  `rustPlatform.buildRustPackage`, com `cargoLock.lockFile` apontando para o
  `Cargo.lock` do workspace.
- Um arquivo por pacote em `pkgs/`, sem lógica repetida.

## Alternativas descartadas

| Alternativa | Por que não |
|---|---|
| `naersk` | Menos controle sobre flags de determinismo e sobre `cargoLock`; mais uma dependência de build. |
| `crane` | Poderoso, mas exige separar dependências e artefatos manualmente; complexidade desnecessária para 9 binários. |
| `fetchCargoVendor` com hash manual | Mais um hash para manter a cada mudança de `Cargo.lock`. `cargoLock.lockFile` já verifica cada crate pelo checksum. |
| `flake-utils` | Uma dependência a mais para 2 sistemas; `lib.genAttrs` resolve. |
| Um pacote por crate de biblioteca | Bibliotecas Rust não têm consumidor Nix útil aqui; o valor está nos binários. |

## Consequências

- O primeiro build resolve e verifica os crates do lock, mesmo para um
  binário pequeno. O cache do Nix amortiza os builds seguintes.
- O `src` local é filtrado para não copiar `target/`, `node_modules/` e
  snapshots para o store.
- O `-Dwarnings` do `.cargo/config.toml` do monorepo é neutralizado por
  `RUSTFLAGS`, para que a política de desenvolvimento não transforme um aviso
  de rustc mais novo em falha de empacotamento.
- Adicionar um crate novo é criar um arquivo em `pkgs/` e registrá-lo em
  `default.nix`.
