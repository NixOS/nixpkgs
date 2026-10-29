# Changelog

## [Não lançado]

### Adicionado

- Toolchain Rust do `rust-toolchain.toml` (1.96.0) via `rust-overlay`
  travado no `flake.lock` (`lib/toolchain.nix`); check `toolchain-version`.
- Fonte por pacote (`lib/workspace.nix`): fecho de crates `path` lido dos
  `Cargo.toml`, alvos vazios para os demais membros.
- Pacote `arkhe-sdd-parser` e alias `arkhe-verify-cli`.
- Checks `tests-arkhe-core` (golden vectors obrigatórios), `tests-arkhe-kernel`,
  `tests-arkhe-governance`, `tests-clippy`, `reproducible-*`, `source-manifest`,
  `sdd-parser-smoke`.
- `scripts/update-source.py` para atualizar o snapshot e o manifesto.

### Alterado

- Snapshot `source/` atualizado do workspace (598 arquivos).
- `arkhe-verify` exige `golden_vectors` e `golden_contract` não vazios no
  checkPhase.
- `arkhe-verify-wasm` compila só para wasm32 e falha na avaliação se
  `wasm-bindgen-cli` diverge do `Cargo.lock`.
- `scripts/check-reproducibility.sh` aceita vários atributos e mantém a
  saída divergente (`--keep-failed`); `verify-content-addressing.sh` não
  depende mais de `jq`.

## [0.1.0] - 2026-10-29

### Adicionado

- Flake com `nixpkgs` fixado, sistemas `x86_64-linux` e `aarch64-linux`.
- Overlay `overlays.default` e overlay CA `overlays.contentAddressed`.
- Construtor `lib/mk-arkhe-package.nix` com `--locked`, `cargoLock.lockFile`,
  build offline, `SOURCE_DATE_EPOCH` e remapeamento de caminhos.
- Pacotes: `arkhe-verify`, `arkhe-runtime`, `arkhe-ask`, `arkhe-sql-migrate`,
  `arkhe-twin`, `arkhe-ollama`, `arkhe-crm-bridge`, `arkhe-python-gate`,
  `arkhe-verify-wasm`.
- Metapacote `arkhe`.
- Módulos NixOS `arkhe-node` e `arkhe-audit`.
- Scripts `check-reproducibility.sh`, `verify-content-addressing.sh` e
  `provenance.sh`.
- Template `nixpkgs/by-name/ar/arkhe-verify/package.nix`.
- Documentação de pacotes, reprodutibilidade e duas ADRs.

### Limitações conhecidas

- Sem `flake.lock` versionado nesta entrega; gerar com `nix flake lock`.
- Sem build executado no ambiente de criação (não havia Nix instalado).
- `arkhe-verify-wasm` depende de toolchain com std para `wasm32-unknown-unknown`.
- Componentes `arkhe-mmrd`, `arkhe-journald`, `arkhe-gate`, `arkhe-anchor` e
  `arkhe-prove` não existem como crates e não foram empacotados.

## Validação complementar — 2026-10-29

- WASM: std do Rust fixado, linker lld explícito e bindings wasm-bindgen para Node.js.
- Pacote WASM exposto no flake e teste funcional com vetores MMR no CI.
- CI constrói todos os pacotes e checks.
- Configuração QEMU/KVM e helpers para reproduzir em store próprio, sem saídas Arkhe copiadas.
- Evidências por pacote em docs/validation/.
