# nixpkgs-arkhe

Pacotes Arkhe para o ecossistema Nix: flake, overlay e módulos NixOS, com
builds reprodutíveis e suporte opt-in a derivações endereçadas por conteúdo.

## Estado (honesto)

| Item | Estado |
|---|---|
| Expressões Nix escritas e revisadas | observado neste diretório |
| `nix flake check` / builds | PASS em x86_64-linux; avaliação ARM64 aprovada; veja a revisão |
| Reprodutibilidade bit-a-bit | dez outputs idênticos entre host e VM QEMU/KVM com store próprio, no mesmo equipamento físico |
| Derivações CA | `arkhe-verify`: build e endereço CA verificados |
| `flake.lock` | versionado; conferir com `nix flake metadata` |
| `arkhe-mmrd`, `arkhe-journald`, `arkhe-gate`, `arkhe-anchor`, `arkhe-prove` | **não existem como crates** neste monorepo; não há pacote para eles |

O workflow em `../.github/workflows/arkhe-nix.yml` repete os checks de build. As execuções locais no host e na VM, com seus hashes e logs, estão registradas em [docs/INTEGRATION-REVIEW.md](docs/INTEGRATION-REVIEW.md).

## O que este repositório entrega

- **8 pacotes nativos e 1 pacote WASM** derivados dos crates que existem no monorepo (ver tabela).
- **1 metapacote** (`arkhe`) que reúne os CLIs em um único perfil.
- **Overlay** (`overlays.default`) e **overlay CA** (`overlays.contentAddressed`).
- **Módulos NixOS** para dois perfis: `arkhe-node` (runtime) e `arkhe-audit`
  (estação offline).
- **Scripts de verificação** de reprodutibilidade, endereçamento por conteúdo e
  proveniência.
- **Template `by-name`** para submissão de `arkhe-verify` ao nixpkgs.

## Pacotes

| Atributo | Crate | Binário | `doCheck` |
|---|---|---|---|
| `arkhe-verify` | `arkhe-verify-cli` | `arkhe-verify` | sim |
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

- `--locked` + `Cargo.lock` com checksum por crate (nenhuma versão flutuante);
- sandbox sem rede e `CARGO_NET_OFFLINE=true`;
- `SOURCE_DATE_EPOCH` fixo;
- `--remap-path-prefix` para remover caminhos absolutos do binário;
- `RUSTFLAGS` explícito, que também neutraliza o `-Dwarnings` do
  `.cargo/config.toml` do monorepo.

Verificação:

```bash
./scripts/check-reproducibility.sh arkhe-verify
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
lib/                   construtor compartilhado
pkgs/                  um arquivo por pacote
modules/               módulos NixOS (node, audit)
checks/                checks do `nix flake check`
scripts/               reprodutibilidade, CA e proveniência
nixpkgs/               template by-name para submissão upstream
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
