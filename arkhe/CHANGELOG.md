# Changelog

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
