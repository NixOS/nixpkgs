# Proposta ao NixOS/nixpkgs

Primeira contribuição preparada: `arkhe-verify`, versão
`0.1.0-unstable-2026-10-29`, com `rafael-arkhe` como mantenedor.
O crate é `arkhe-verify-cli`; o executável instalado é `arkhe-verify`.
O PR oficial ainda não foi aberto e aguarda revisão humana da proposta.

## Arquivos para revisão

- [Receita by-name](by-name/ar/arkhe-verify/package.nix), com hashes reais.
- [Patch com dois commits](arkhe-verify-upstream.patch): cadastro de mantenedor
  e inclusão do pacote, separados conforme a convenção do Nixpkgs.
- [Descrição proposta do PR](pull-request.md), com divulgação da assistência do
  OpenAI Codex (GPT-6). Os commits incluem trailers `Assisted-by:`.
- [Resultados e limitações](../docs/validation/nixpkgs-upstream/results.json),
  acompanhados pelos logs de build, testes e reconstrução.

A receita não é importada pelo flake do overlay. Ela destina-se ao checkout do
Nixpkgs com a entrada de mantenedor aplicada pelo patch; copiar somente a receita
sem cadastrar `rafael-arkhe` deixa `meta.maintainers` incompleto.

## Fonte pública imutável

A revisão `228da8e803e9f81041066e3a3a50f61e6ff4201c` em
[rafael-arkhe/nixpkgs-arkhe](https://github.com/rafael-arkhe/nixpkgs-arkhe/tree/228da8e803e9f81041066e3a3a50f61e6ff4201c)
contém somente os fontes do workspace Arkhe, incluindo Cargo.lock. É a árvore
`arkhe/source` do commit de integração
`9c1d848c9b08ff7c9ac9b685c3f586717ed6d082`, publicada na raiz da branch
independente `arkhe/source-2026-10-29`. O manifesto original está em
[`source-manifest.json`](../source-manifest.json).

Esse commit de fontes não inclui a árvore do Nixpkgs. Não se pressupõe uma
tag v0.1.0: a versão unstable identifica o snapshot utilizado.

| Entrada | Hash fixado |
|---|---|
| Fonte | `sha256-IX8kHrWuRQn9jOb1mwXwJ9eoMkelO+1PpFlbu/dEiiI=` |
| Dependências Cargo | `sha256-J2aSDP8/OcFVQdilWyYs+4f8VXwhxEhT9uSh+8egyH8=` |

## Verificação observada

Em 29/10/2026, Ubuntu WSL x86_64-linux, Nix 2.35.4, sobre a base
NixOS/nixpkgs `0470df609861fede4cec47148a001f04513bdabc`:

- Build e testes de arkhe-core, arkhe-verify-core e CLI passaram.
- Quatro golden vectors e um golden contract passaram, exigidos explicitamente.
- Teste passthru BLAKE3 da entrada vazia passou.
- `nix-build --check` passou, com saída reconstruída bit a bit idêntica.
- Schema de mantenedores, nixfmt e verificação do diff passaram.

Hash NAR da saída: `sha256-aVjRxtMiLJv/rvdYT+qPMMWF3zDMCaCeWbEN3cK5ak8=`.
Essa receita usa o Rust 1.99.0 padrão da base Nixpkgs; o overlay usa Rust 1.96.0
fixado e tem [evidências próprias](../docs/validation/rust-1.96.0/results.json).
Outra máquina/VM, aarch64, Darwin e nixpkgs-review não foram executados nesta
rodada da receita upstream.

## Repetir em um checkout Linux

Partindo da base acima e do patch salvo fora do checkout:

```sh
git switch -c arkhe-verify-init 0470df609861fede4cec47148a001f04513bdabc
git am /caminho/arkhe-verify-upstream.patch
nix-build -A arkhe-verify --no-out-link
nix-build -A arkhe-verify.tests --no-out-link
nix-build -A arkhe-verify --check --keep-failed --no-out-link
nix-build lib/tests/maintainers.nix --no-out-link
nix-shell -p nixfmt --run 'nixfmt --check pkgs/by-name/ar/arkhe-verify/package.nix maintainers/maintainer-list.nix'
git diff --check
```

Fonte e dependências são fixed-output; build e testes usam `--frozen`, offline
e sandbox. Não há importação de Cargo.lock de uma derivação durante a avaliação.
A receita oficial não exige `ca-derivations`: a variante CA experimental
permanece no overlay. O layout by-name dispensa entrada em `all-packages.nix`.

A proposta inicial limita-se ao verificador nativo; WASM, SDD e os demais pacotes
continuam no overlay. Publicar este material no fork não equivale à aceitação no
Nixpkgs. Antes da submissão, o responsável deve revisar o diff e a descrição
segundo a [política de automação/IA](https://github.com/NixOS/nixpkgs/blob/0470df609861fede4cec47148a001f04513bdabc/CONTRIBUTING.md#automationai-policy).
