# nixpkgs-arkhe

Pacotes Arkhe para o ecossistema Nix: flake, overlay e módulos NixOS, com
builds reprodutíveis e suporte opt-in a derivações endereçadas por conteúdo.

## Estado (honesto)

| Item | Estado |
|---|---|
| Expressões Nix escritas e revisadas | observado neste diretório |
| `nix flake check` / builds | PASS em x86_64-linux (24 checks, 2026-10-29, Nix 2.35.4 no Ubuntu WSL, Rust 1.96.0 do rust-overlay); aarch64 não construído |
| Reprodutibilidade bit-a-bit | `arkhe-verify`, `arkhe-verify-wasm`, `arkhe-sdd-parser`: `--rebuild` e `reproducible-*` idênticos na mesma máquina (hashes abaixo). A comparação host × VM registrada em [docs/INTEGRATION-REVIEW.md](docs/INTEGRATION-REVIEW.md) é da versão anterior (rustc do nixpkgs) e **não foi repetida** com a toolchain 1.96.0 |
| Derivações CA | `arkhe-verify`: build CA com `ca=fixed:r:sha256:…`; mesmo `narHash` do build normal |
| `flake.lock` | versionado; `nixpkgs` 31ecbac…, `rust-overlay` afcefd0…; conferir com `nix flake metadata` |
| `arkhe-mmrd`, `arkhe-journald`, `arkhe-gate`, `arkhe-anchor`, `arkhe-prove` | **não existem como crates** neste monorepo; não há pacote para eles |

`narHash` observados (x86_64-linux, 2026-10-29):

| Pacote | narHash |
|---|---|
| `arkhe-verify` | `sha256-+vmDoCqrEz9UPSLIPhB8oI6wXUCSB6tg3U5OUkQXAS0=` |
| `arkhe-verify-wasm` | `sha256-UQi2HohdpttuenoFcZ22EZVw8FW+GaN3aYFNRngIgn4=` |
| `arkhe-sdd-parser` | `sha256-MG84KZNsiV1eEVbbwiit4dWBlrM2EO7e3R5xwzyvChU=` |

Os mesmos três `narHash` saíram de um clone limpo do commit em ext4,
construído do zero: conteúdo idêntico entre checkouts diferentes.

**Caminho de store depende do sistema de arquivos do checkout.** No WSL,
arquivos em `/mnt/<drive>` aparecem como `rwxrwxrwx`; o bit executável entra
no hash da fonte, então o `.drv` e o caminho de saída diferem de um checkout
em ext4, embora o `narHash` da saída seja o mesmo (observado acima). Para
caminhos comparáveis entre máquinas, construa a partir de um checkout em
sistema de arquivos Linux, ou compare `narHash`/use as variantes CA.

Num checkout git, arquivos novos só entram no flake depois de `git add`;
para testar antes disso use `nix flake check path:$PWD`. O `.gitignore`
global desta máquina ignora `lib/`: adicione `arkhe/lib` com `git add -f`.

O workflow em `../.github/workflows/arkhe-nix.yml` repete os checks de build. A rodada atual Rust 1.96.0 está registrada em [docs/validation/rust-1.96.0/results.json](docs/validation/rust-1.96.0/results.json). A rodada anterior com Rust 1.99.0 e VM está preservada em [docs/INTEGRATION-REVIEW.md](docs/INTEGRATION-REVIEW.md).

## O que este repositório entrega

- **9 pacotes nativos e 1 pacote WASM** derivados dos crates que existem no monorepo (ver tabela).
- **1 metapacote** (`arkhe`) que reúne os CLIs em um único perfil.
- **Overlay** (`overlays.default`) e **overlay CA** (`overlays.contentAddressed`).
- **Módulos NixOS** para dois perfis: `arkhe-node` (runtime) e `arkhe-audit`
  (estação offline).
- **Scripts de verificação** de reprodutibilidade, endereçamento por conteúdo e
  proveniência.
- **Receita `by-name` validada** para a proposta de `arkhe-verify` ao nixpkgs,
  com fontes públicas e hashes reais; [estado e diff](nixpkgs/README.md).

## Pacotes

| Atributo | Crate | Binário | `doCheck` |
|---|---|---|---|
| `arkhe-verify` (alias `arkhe-verify-cli`) | `arkhe-verify-cli` | `arkhe-verify` | sim, com golden vectors obrigatórios |
| `arkhe-sdd-parser` | `arkhe-sdd-parser` | `arkhe-sdd-parser` | sim |
| `arkhe-runtime` | `arkhe-runtime` | `arkhe-runtime` | não |
| `arkhe-ask` | `arkhe-ask` | `arkhe-ask` | não |
| `arkhe-sql-migrate` | `arkhe-sql-migrate` | `arkhe-sql-migrate` | não |
| `arkhe-twin` | `arkhe-twin` | `arkhe-twin` | não |
| `arkhe-ollama` | `arkhe-ollama` | `arkhe-ollama` | não |
| `arkhe-crm-bridge` | `arkhe-crm-bridge-cli` | `arkhe-crm-bridge-cli` | não |
| `arkhe-python-gate` | `arkhe-python-bridge` | `arkhe-python-gate` | não |
| `arkhe-verify-wasm` | `arkhe-verify-wasm` | `arkhe-verify.wasm` | não |
| `arkhe` | — | metapacote (`symlinkJoin`) | — |

Detalhes, dependências pesadas e riscos por pacote: [docs/packages.md](docs/packages.md).

## Uso

### Flake

```bash
nix build .#arkhe-verify
nix run .#arkhe-verify -- --help
nix build .#arkhe                # metapacote com todos os CLIs
nix develop                      # cargo, rustc, clippy, rustfmt, jq, nix
```

O flake usa o snapshot `source/`, acompanhado de `source-manifest.json`. No fork Nixpkgs, execute estes comandos dentro de `arkhe/`. Para outro workspace, passe `src` explicitamente à API `lib.mkPackages` ou a `default.nix`.

### Overlay

```nix
{
  inputs.nixpkgs-arkhe.url = "github:rafael-arkhe/nixpkgs-arkhe?dir=arkhe";

  nixpkgs.overlays = [ inputs.nixpkgs-arkhe.overlays.default ];
  environment.systemPackages = [ pkgs.arkhe.arkhe-verify ];
}
```

### Perfil de usuário

```bash
nix profile install .#arkhe
```

### Fonte versionada

O snapshot local está versionado junto ao pacote. O commit do flake fixa os fontes; `source-manifest.json` registra SHA-256 por arquivo e é conferido pelo CI. O workspace público `rafael-arkhe/arkhe` tem outra estrutura e não deve ser usado como substituto automático deste snapshot.

```nix
let
  arkhe = import ./default.nix {
    inherit pkgs;
    src = ./source;
  };
in
arkhe.arkhe-verify
```

Para outra fonte, forneça um snapshot com `Cargo.lock` e os mesmos crates, fixado por revisão/hash, e repita os checks.

## Reprodutibilidade

O construtor aplica, em todos os pacotes:

- **toolchain fixada**: Rust do `source/rust-toolchain.toml` (hoje 1.96.0),
  via `rust-overlay` travado no `flake.lock`; o check `toolchain-version`
  confirma o `rustc --version`. O `rustc` do nixpkgs não é usado;
- **fonte por pacote** (`lib/workspace.nix`): cada derivação recebe só o fecho
  de crates `path` do pacote (lido dos `Cargo.toml`), os `Cargo.toml` dos
  demais crates e os arquivos externos declarados em `crateExtras`
  (`default.nix`). Editar um crate fora do fecho não muda o hash da fonte.
  Ver `nix eval .#arkhe-verify.sourceCrates`. Observado: acrescentar uma linha
  em `source/apps/arkhe-ask/src/auth.rs` muda o `.drv` de `arkhe-ask` e mantém
  os de `arkhe-verify` e `arkhe-sdd-parser`;
- `--locked` + `Cargo.lock` com checksum por crate (nenhuma versão flutuante);
  o vendor de crates é uma derivação de saída fixa por crate;
- sandbox sem rede e `CARGO_NET_OFFLINE=true`;
- `SOURCE_DATE_EPOCH` fixo;
- `--remap-path-prefix` para remover caminhos absolutos do binário;
- `RUSTFLAGS` explícito; o `.cargo/config.toml` do monorepo (`-Dwarnings`)
  não entra no snapshot.

### Como verificar

```bash
cd arkhe

# 1. Snapshot confere com o manifesto SHA-256
python3 scripts/validate-source.py
python3 scripts/check-source-filter.py

# 2. Todos os pacotes, suítes de teste, clippy e as segundas construções
nix build .#arkhe-verify-cli .#arkhe-verify-wasm .#arkhe-sdd-parser
nix flake check --no-update-lock-file -L

# 3. Rebuild contra a saída já registrada no store (bit a bit)
./scripts/check-reproducibility.sh arkhe-verify arkhe-verify-wasm arkhe-sdd-parser

# 4. Hash NAR para comparar com outra máquina
nix path-info --json .#arkhe-verify | jq -r '.[].narHash'
```

O que cada check prova:

| Check | Prova |
|---|---|
| `arkhe-verify` (checkPhase) | testes de `arkhe-verify-cli`, `arkhe-verify-core` e `arkhe-core` passam; `golden_vectors` e `golden_contract` executam ao menos um teste cada, com o mesmo compilador do binário |
| `tests-arkhe-core`, `tests-arkhe-kernel`, `tests-arkhe-governance` | `cargo test` dos crates de núcleo; `tests-arkhe-core` exige `golden_vectors` não vazio |
| `arkhe-sdd-parser` + `sdd-parser-smoke` | testes do parser; CLI gera `constitution.cbor`/`tasks.cbor` idênticos em duas execuções |
| `tests-clippy` | `clippy -D warnings --all-targets` em core, kernel, governance, sdd-parser e verify. **Exceções** para lints que já falham no monorepo: `too_many_arguments` (`arkhe-governance`) e `useless_vec` (`arkhe-kernel/tests/support/gravit_signatures.rs:279`); remover cada uma quando o código for corrigido |
| `reproducible-*` | segunda construção independente (outra derivação, outro sandbox, outro horário) idêntica byte a byte (`diff -r`) |
| `source-manifest` | `source/` confere com `source-manifest.json` |
| `toolchain-version` | `rustc` é o do `rust-toolchain.toml` |

`reproducible-*` não varia o diretório de build (`/build`), o kernel nem a
máquina. Para isso, compare o `narHash` do passo 4 entre máquinas, ou use a
VM descrita em [docs/vm-reproduction.md](docs/vm-reproduction.md).

### Atualizar o snapshot

```bash
python3 scripts/update-source.py /caminho/do/monorepo [caminho-novo ...]
python3 scripts/validate-source.py
```

Recopia todo arquivo listado no manifesto (arquivo ausente aborta), adiciona os
caminhos novos e regrava `source-manifest.json`.

Proveniência:

```bash
./scripts/provenance.sh . arkhe-verify arkhe-sql-migrate
```

O que **não** é garantido: igualdade bit-a-bit entre versões diferentes de
`rustc`, `binutils` ou `nixpkgs`. Reprodutibilidade é relativa a um
`flake.lock`. Leia [docs/reproducibility.md](docs/reproducibility.md) antes de
afirmar "100% reprodutível".

## Derivações endereçadas por conteúdo (CA)

O modo CA é opt-in e exige a feature experimental `ca-derivations`:

```bash
nix build .#legacyPackages.x86_64-linux.ca.arkhe-verify \
  --extra-experimental-features "nix-command flakes ca-derivations"

./scripts/verify-content-addressing.sh arkhe-verify
```

Para NixOS:

```nix
nixpkgs.overlays = [
  inputs.nixpkgs-arkhe.overlays.contentAddressed
];
```

As variantes CA ficam em `legacyPackages.<system>.ca` justamente para que
`nix flake check` continue funcionando em instalações sem a feature habilitada.

**Por que CA não é o padrão.** Ganho: o caminho de store passa a ser o hash
do conteúdo, então duas construções que divergem ganham caminhos distintos, e
dependentes não são reconstruídos quando a saída não muda (early cutoff).
Custo: `ca-derivations` ainda é experimental; exige a feature em todo
avaliador e builder, assinaturas de cache passam a ser por *realisation*,
e o suporte em Hydra/caches de terceiros é parcial. CA também **não** torna o
build determinístico: isso vem dos itens acima. Só o pacote final vira CA;
toolchain e dependências continuam endereçados por entrada. Fontes já são de
saída fixa: o snapshot entra no store pelo `narHash` do flake e cada crate do
`Cargo.lock` é baixado por checksum. Detalhes em
[docs/adr/0002-builds-enderecados-por-conteudo.md](docs/adr/0002-builds-enderecados-por-conteudo.md).

## Módulos NixOS

```nix
{
  imports = [ inputs.nixpkgs-arkhe.nixosModules.arkhe-node ];

  services.arkheNode = {
    enable = true;
    environmentFile = "/run/secrets/arkhe.env";
  };
}
```

`services.arkheAudit` instala o verificador e prepara `/var/lib/arkhe-audit`,
sem habilitar nenhum serviço de rede. Ambos exigem o overlay carregado
(`pkgs.arkhe.*`).

## Estrutura

```text
flake.nix              saídas do flake (packages, checks, modules, apps)
default.nix            conjunto de pacotes parametrizado por `src`
overlay.nix            overlay (normal e CA)
lib/                   construtor, fonte por pacote e toolchain fixada
pkgs/                  um arquivo por pacote
modules/               módulos NixOS (node, audit)
checks/                checks do `nix flake check`
scripts/               reprodutibilidade, CA e proveniência
nixpkgs/               receita by-name validada, patch e proposta upstream
docs/                  pacotes, reprodutibilidade e ADRs
```

## Limites

- Não substitui HSM, certificação ICP-Brasil ou avaliação de conformidade.
- Não prova que o sistema é seguro; prova o que foi construído e com quais
  entradas.
- Os perfis `arkhe-node`/`arkhe-audit` aqui são módulos de instalação, não a
  cadeia de boot medida (Secure Boot, UKI, TPM, IMA) descrita na arquitetura
  Arkhe Linux.

## Licença

Apache-2.0. Ver [LICENSE](LICENSE).

## Revisão de integração

Veja [docs/INTEGRATION-REVIEW.md](docs/INTEGRATION-REVIEW.md). A raiz do fork Nixpkgs permanece independente.

O pacote WASM usa `lld` e `wasm-bindgen-cli` do mesmo nixpkgs fixado. Inclui o módulo bruto `lib/arkhe-verify.wasm` e bindings Node.js `lib/arkhe_verify.js`. A nomenclatura não implica habilitação da camada PQC.

A verificação do overlay consumidor e o teste de isolamento de fontes estão registrados em `docs/validation/rust-1.96.0/`. O probe altera apenas uma cópia temporária do snapshot; o checkout original permanece intacto. Também cobre projetos Cargo não declarados e arquivos gerados de wasm-bindgen.
