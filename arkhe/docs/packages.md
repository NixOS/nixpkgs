# Pacotes

Todos os pacotes usam `lib/mk-arkhe-package.nix`, que fixa `--locked`,
`Cargo.lock`, `SOURCE_DATE_EPOCH`, remapeamento de caminho e build offline.

## `arkhe-verify`

- Crate: `verification/crates/arkhe-verify-cli`
- Binário: `arkhe-verify`
- `doCheck = true`: testa também `arkhe-verify-core` e `arkhe-core`, que contêm os vetores locais.
- É o pacote mais leve e o único com smoke test (`--help`) em `checks`.
- Candidato natural à submissão no nixpkgs (`nixpkgs/by-name/ar/arkhe-verify`).

## `arkhe-runtime`

- Crate: `orchestration/arkhe-runtime`
- Binário: `arkhe-runtime`
- `doCheck = false`: exige PostgreSQL, token e ator.
- Dependências pesadas: `axum`, `sqlx` (Postgres), `tokio`.
- Lê `DATABASE_URL`, `ARKHE_API_TOKEN`, `ARKHE_ACTOR`, `ARKHE_TENANT_ID` e
  `ARKHE_LISTEN` (padrão `127.0.0.1:8788`).

## `arkhe-ask`

- Crate: `apps/arkhe-ask`
- Binário: `arkhe-ask`
- `doCheck = false`: exige PostgreSQL/pgvector e Kafka opcional.
- Dependências mais pesadas do conjunto: `opentelemetry*`, `rskafka`,
  `axum-keycloak-auth`, `pgvector`. É o build mais longo.
- Escuta em `ARKHE_LISTEN` (padrão `127.0.0.1:3000`).

## `arkhe-sql-migrate`

- Crate: `storage/sql/crates/arkhe-sql-migrate`
- Binário: `arkhe-sql-migrate`
- `doCheck = false`: migrações exigem banco acessível.

## `arkhe-twin`

- Crate: `work/arkhe-twin`
- Binário: `arkhe-twin`
- `doCheck = false`.

## `arkhe-ollama`

- Crate: `integration/arkhe-ollama`
- Binário: `arkhe-ollama`
- `doCheck = false`: os testes sobem um servidor axum local.

## `arkhe-crm-bridge`

- Crate: `integration/arkhe-crm-bridge` (pacote Cargo `arkhe-crm-bridge-cli`)
- Binário: `arkhe-crm-bridge-cli` (o crate não declara `[[bin]]`, então o nome
  do binário é o nome do pacote Cargo)
- `doCheck = false`.
- `rusqlite` com feature `bundled`: compila o SQLite a partir do fonte; não
  precisa de `sqlite` externo nem de `pkg-config`.

## `arkhe-python-gate`

- Crate: `integrations/arkhe-python-runtime/bridge` (pacote Cargo
  `arkhe-python-bridge`)
- Binário: `arkhe-python-gate` (declarado em `[[bin]]`)
- `doCheck = false`.
- O crate também é `cdylib`, mas o pacote instala apenas o binário.

## `arkhe-verify-wasm`

- Crate: `verification/crates/arkhe-verify-wasm`
- Artefato: `$out/lib/arkhe-verify.wasm`
- `doCheck = false`; `installPhase` próprio.
- Usa a std WASM do rustc fixado, `lld` explícito e `wasm-bindgen-cli` compatível.
- Inclui bindings Node.js. O check `wasm-smoke` executa 20 provas MMR válidas, 106 adulterações e uma política malformada.
- Faz parte de `packages`, `checks` e do CI.

## `arkhe`

- Metapacote `symlinkJoin` com os oito CLIs.
- Não inclui o artefato WASM.

## O que não está aqui

Não existem pacotes para `arkhe-mmrd`, `arkhe-journald`, `arkhe-gate`,
`arkhe-anchor` ou `arkhe-prove`: esses componentes aparecem na arquitetura
Arkhe Linux, mas não há crate correspondente neste monorepo. Criar pacotes para
eles seria inventar software.
