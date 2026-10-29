# Reprodutibilidade e endereçamento por conteúdo

Este documento separa o que foi **implementado**, o que foi **observado** e o
que **ainda não foi verificado**.

## Mecanismos aplicados

| Mecanismo | O que fixa | Onde |
|---|---|---|
| `inputs.nixpkgs` | versão do nixpkgs, rustc, binutils, stdenv | `flake.nix` + `flake.lock` versionado |
| `cargoLock.lockFile` | cada crate por checksum registrado no `Cargo.lock` | `lib/mk-arkhe-package.nix` |
| `cargoLock.allowBuiltinFetchGit = false` | impede dependência git não fixada | idem |
| `--locked` | impede o Cargo de resolver versões novas | idem |
| sandbox do Nix + `CARGO_NET_OFFLINE=true` | nenhuma rede durante o build | idem |
| `SOURCE_DATE_EPOCH = 315532800` | timestamps embutidos | idem |
| `RUSTFLAGS` com `--remap-path-prefix` | remove caminhos absolutos do binário | idem |
| `CARGO_INCREMENTAL=0` | evita artefatos incrementais não determinísticos | idem |
| `TZ=UTC`, `LC_ALL=C` | locale e fuso | idem |

Além disso, o `src` local é filtrado (`default.nix`): `target/`, `node_modules/`,
snapshots e binários de release não entram no store. Quando `src` é uma
derivação (`fetchFromGitHub`/`fetchgit`), o filtro não se aplica — a fonte já é
fixada por hash.

## O que isso garante

- Que o build não depende de rede, de versões flutuantes de crates ou de
  caminhos da máquina.
- Que o mesmo `flake.lock` + mesmo `src` produzem o mesmo derivado.
- Que cada dependência de crate é verificada pelo checksum do `Cargo.lock`.

## O que isso **não** garante

- Igualdade bit-a-bit entre versões diferentes de `rustc`, `binutils`, `gcc` ou
  `nixpkgs`. Reprodutibilidade é sempre **relativa a um lock**.
- Que o resultado é idêntico entre `x86_64-linux` e `aarch64-linux` (não é, e
  não se espera que seja).
- Que o conteúdo é "prova de segurança". Reprodutibilidade prova consistência
  de build, não ausência de vulnerabilidade.

## Como verificar

```bash
# 1. Reconstrói e compara o conteúdo produzido
./scripts/check-reproducibility.sh arkhe-verify

# 2. Emite proveniência (versão do Nix, locked rev, hash por pacote)
./scripts/provenance.sh . arkhe-verify arkhe-sql-migrate

# 3. Verifica o caminho endereçado por conteúdo (requer ca-derivations)
./scripts/verify-content-addressing.sh arkhe-verify
```

Para uma afirmação forte, o mínimo é: `flake.lock` versionado, build em duas
máquinas independentes, `nix hash path` igual nas duas, e o mesmo
`nix path-info --json` para o fecho de dependências.

## Derivações endereçadas por conteúdo (CA)

`contentAddressed = true` adiciona `__contentAddressed = true;` e
`outputHashMode = "recursive";` ao derivado. Com a feature experimental
`ca-derivations`, o caminho no store passa a ser derivado do conteúdo produzido,
e não do hash das entradas.

Consequências práticas:

- O endereço reflete o conteúdo produzido. A verificação de determinismo exige
  reconstrução e comparação separadas.
- Ainda é experimental no Nix; não é o modo padrão.
- As variantes CA ficam em `legacyPackages.<system>.ca` para que
  `nix flake check` não tente instanciá-las em instalações sem a feature.

## Estado da evidência

| Afirmação | Estado |
|---|---|
| As expressões Nix existem e referenciam crates reais do monorepo | observado (inspeção dos arquivos e dos `Cargo.toml`) |
| Avaliação `nix flake check --no-build --all-systems` | **PASS** em WSL/Nix 2.35.4 |
| `arkhe-verify` constrói | **PASS** em x86_64-linux |
| Dez outputs reproduzidos em VM com store próprio | **PASS**; hashes e derivações idênticos ao host |
| `arkhe-verify` CA tem endereço de conteúdo | **PASS** |
| Todos os pacotes, incluindo `arkhe-ask` e WASM, constroem | **PASS** em x86_64-linux |

Nenhuma linha acima deve ser lida como "passou". O CI é quem produz essa
evidência.

## Riscos conhecidos

1. **`arkhe-ask`**: `opentelemetry`, `rskafka`, `axum-keycloak-auth` e
   `pgvector` aumentam muito o tempo de build e a superfície de falha.
2. **`arkhe-crm-bridge`**: `rusqlite` com `bundled` compila SQLite; exige
   compilador C no stdenv (disponível), mas aumenta o tempo de build.
3. **`arkhe-verify-wasm`**: depende de toolchain com std para
   `wasm32-unknown-unknown`.
4. **Workspace compartilhado**: `cargoLock.lockFile` resolve os pacotes do
   `Cargo.lock` para cada pacote. O cache do Nix amortiza, mas o primeiro build
   baixa e verifica tudo.
5. **Toolchain efetivo**: estes builds usam Rust 1.99.0 do nixpkgs fixado pelo `flake.lock`, independentemente do arquivo `rust-toolchain.toml` do workspace original.

## Ensaio em VM concluído

Oito executáveis, o WASM e o metapacote foram compilados em uma VM QEMU/KVM com kernel e discos próprios, sem montagem do store do host. O seed excluiu todos os outputs Arkhe, verificados ausentes no início. Os dez hashes e derivações coincidiram com o host. Dependências e toolchain foram fornecidos como insumos fixados comuns; host e VM usam o mesmo equipamento físico. Veja [comparação](validation/vm/comparison.json) e [procedimento](vm-reproduction.md).
