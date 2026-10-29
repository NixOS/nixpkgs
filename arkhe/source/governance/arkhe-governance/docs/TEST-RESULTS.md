# Resultados de verificação — 26/10/2026

Ambiente: D:\arkhe, Windows/MSVC, Rust 1.96.0. Execução local real.

Resultado após normalização de signed zero: 55 verificações sem DuckDB e 57 com DuckDB.
Nesta implementação multi-cloud foi adicionada a regressão
`cold_start_and_conflict_never_invoke_comparisons`: 56 verificações sem DuckDB
aprovadas (54 unitárias/integração + 2 doctests). O backend desse teste entra em
panic se houver comparação em cold start/conflito, mesmo com thresholds zero.
A feature DuckDB não foi reexecutada nesta rodada; 57 é resultado histórico.
As seções anteriores à última registram o histórico dos incrementos.

## Execução inicial (antes da revisão de conflitos múltiplos)

| Comando | Resultado |
|---|---|
| cargo test -p arkhe-governance --target-dir target/invariant-resolver-check | PASS: 15 unitários + 18 integração + 1 doctest compile_fail = 34 |
| cargo test -p arkhe-governance --features duckdb-backend --no-run | PASS: backend bundled compilado a partir do C++; DuckDB 1.20000.0 |
| cargo test -p arkhe-governance --features duckdb-backend | PASS: 15 unitários + 19 integração + 1 doctest = 35 |
| cargo test -p arkhe-governance --test invariant_resolver | PASS: 18 testes de integração |
| rustfmt --check --edition 2021 nos cinco arquivos Rust novos | PASS |
| cargo clippy -p arkhe-governance --all-targets --no-deps --target-dir target/invariant-resolver-check -- -D warnings | FAIL inicial: too_many_arguments preexistente em policy_bundle.rs:260; dois avisos do resolver corrigidos |
| cargo clippy -p arkhe-governance --all-targets --no-deps --target-dir target/invariant-resolver-check -- -D warnings -A clippy::too_many_arguments | PASS após correções; exceção explícita para lint preexistente |

Os totais incluem 12 testes anteriores de policy_bundle. Os testes de integração
cobrem os cinco veredictos, as nove combinações de modalidade, cold start mesmo
com thresholds zero, exclusão do ID do candidato, isolamento entre ações,
cache estável sob reordenação e invalidado por membros/ações, erros de configuração,
falha de log em todos os caminhos de decisão e a banda de refinamento.

Há três testes unitários novos: dois de estabilidade/valores numéricos do EM e
um de invalidação do cache por parâmetros EM e comparações. O doctest verifica
que acessar ComputedVerdict.0 não compila.

O teste adicional DuckDB compara pares e vetores com InMemoryBackend, reutiliza
a conexão, consulta vazio após corpus preenchido, executa três chamadas
concorrentes e verifica equivalência do resultado final do resolver.

A primeira execução do código fornecido encontrou erros de tipos e três
expectativas probabilísticas falsas. A versão final preserva esses três corpora
como regressão de Novel e usa corpus sintético distinto para os testes positivos.
Não houve redução dos thresholds padrão para acomodar os testes.

O target-dir separado permitiu validar a suíte padrão durante a compilação C++.
Cargo.lock foi atualizado com a dependência opcional DuckDB e suas transitivas.
Não foram executados testes de todo o workspace, benchmarks de escala ou avaliação
com dados comerciais rotulados. Os resultados não demonstram calibração do score,
persistência WORM ou uma plataforma completa de knowledge graph.

Arquivos implementados: src/constitution_graph.rs, src/er_backend.rs,
src/fellegi_sunter.rs, src/invariant_resolver.rs, tests/invariant_resolver.rs.
Integração: módulos exportados em src/lib.rs; dependências/features no Cargo.toml.
Revisão técnica: ADR-0001-invariant-resolver.md.
Avaliação da vaga: JOB-SKILLS-ASSESSMENT.md.

## Revisão de conflitos múltiplos — histórico anterior ao snapshot

Documentado no enum e no ADR: Conflict contém um testemunho escolhido pelo menor
ID, sem prioridade semântica e sem enumerar todos os conflitos. Nenhum tipo público
ou comportamento de decisão foi alterado.

Adicionado multiple_conflicts_report_one_stable_witness_without_semantic_priority:
verifica seleção do menor ID com ordem invertida, igualdade ASCII sem distinção
de caixa, especificidade/data maiores no outro registro e um append por chamada.

| Comando executado | Resultado atual |
|---|---|
| cargo test -p arkhe-governance --target-dir target/invariant-resolver-check | PASS: 15 unitários + 19 integração + 1 doctest = 35 |
| cargo test -p arkhe-governance --features duckdb-backend | PASS: 15 unitários + 20 integração + 1 doctest = 36 |
| rustfmt --check --edition 2021 nos dois arquivos Rust alterados | PASS |

O ADR também distingue o resultado observado dos três corpora pequenos de uma
atribuição causal exclusiva à não-identificabilidade e esclarece que prior 0.3
é contrafactual no resolver atual. Não foi demonstrado teto universal de 0.17.

## OntologySnapshot — histórico anterior aos bindings

Implementado o perfil arkhe-invariant-snapshot-v1: snapshot imutável por conteúdo,
OntologyVersion, ordenação por ID, rejeição de IDs duplicados, carga tipada com
verificação de versão, digests canônicos do candidato/corpus e resolve_snapshot.
O schema do ResolutionRecord permanece inalterado.

| Comando executado | Resultado |
|---|---|
| python governance/arkhe-governance/tests/fixtures/generate_snapshot_vectors.py | PASS: vetores gerados por encoder Python independente, biblioteca padrão |
| cargo test -p arkhe-governance --target-dir target/invariant-resolver-check | PASS: 15 unitários + 19 integração resolver + 8 integração snapshot + 2 doctests = 44 |
| cargo test -p arkhe-governance --features duckdb-backend | PASS: 15 unitários + 20 integração resolver + 8 integração snapshot + 2 doctests = 45 |
| cargo test -p arkhe-governance --test ontology_snapshot --target-dir target/invariant-resolver-check | PASS: 8 testes, repetidos após reforçar a comparação com caches vazios |
| cargo clippy -p arkhe-governance --all-targets --no-deps --target-dir target/invariant-resolver-check -- -D warnings -A clippy::too_many_arguments | PASS; mesma exceção preexistente documentada |
| rustfmt --check --edition 2021 nos três arquivos Rust novos/alterados de implementação e teste | PASS |

A projeção AKG-CBOR-v1 reutiliza o encoder arkhe-core existente, sem alterações
nesse crate. Vetores independentes verificam snapshot vazio, identidade em byte
string, UTF-8 e limites u32/u64. Testes exercitam mudança em todos os campos,
permutação, verificação de versão, corpus selecionado e isolamento de mutação.

O novo doctest compile_fail confirma acesso somente de leitura à coleção do
snapshot. O teste de equivalência do adapter foi reforçado para comparar o score
em bits com um resolver distinto de cache vazio, após inverter o corpus; esse
caso também foi repetido na configuração DuckDB.

Escopo: invariantes, sem arestas/cobertura de um ConstitutionGraph completo.
Não há persistência de snapshots, reader CBOR, bindings de replay no registro,
executor de replay ou demonstração de igualdade numérica entre plataformas.
Ver ADR-0002-ontology-snapshot.md para o contrato e as pendências.

## Seis bindings / Frente A — histórico anterior à normalização de zero

Implementados ResolverParams/ParamsDigest, AlgorithmVersion/ComparisonVersion,
ResolutionBindings e ResolutionContext. Registro e LogFailure preservam os seis
bindings; o registro mantém parâmetros/versões. O domínio de hash é agora
AKG:ONTO:RESOLUTION:v2, com CBOR canônico e floats codificados por bits uint64.

| Comando executado | Resultado |
|---|---|
| python governance/arkhe-governance/tests/fixtures/generate_params_vector.py | PASS: vetor CBOR independente com IEEE-754 via struct da biblioteca padrão Python |
| cargo test -p arkhe-governance --target-dir target/invariant-resolver-check | PASS: 15 unitários + 19 integração resolver + 8 snapshot + 9 bindings + 2 doctests = 53 |
| cargo test -p arkhe-governance --features duckdb-backend | PASS: 15 unitários + 20 integração resolver + 8 snapshot + 10 bindings + 2 doctests = 55 |
| cargo clippy -p arkhe-governance --all-targets --no-deps --target-dir target/invariant-resolver-check -- -D warnings -A clippy::too_many_arguments | PASS; exceção preexistente mantida |
| rustfmt --check --edition 2021 nos cinco arquivos Rust novos/alterados de implementação e teste | PASS |

Nove testes novos cobrem bindings em sete cenários de decisão, identidade de
registro nas duas entradas, seis adulterações rejeitadas sem blocking/scoring/log,
mudanças de inputs/configuração/payload, hash de todos os campos do registro,
parâmetros exatos e inválidos, vetor CBOR independente, inicialização do modelo e
rejeição de backend sem versão. O teste extra DuckDB verifica igualdade dos seis
bindings, bytes canônicos e digest do registro entre backends.

O teste anterior de falha de log foi reforçado para comparar integralmente o
ResolutionContext de LogFailure com o do registro correspondente, mantendo a
verificação de partial_digest. Wrappers de backend nos testes declaram a versão
suportada explicitamente; implementações desconhecidas falham antes de executar.

A entrada resolve(candidate, existing) continua disponível e cria um snapshot;
resolve_snapshot é o caminho compartilhado. Record literals e matches exaustivos
de LogFailure exigem migração para os campos novos. Ver ADR-0003 para detalhes.

A checagem verify_record_inputs não reexecuta nem autentica decisões. Perfil do
grafo completo (Frente B), executor/artefatos de replay, armazenamento durável e
calibração continuam pendentes. Os testes não demonstram portabilidade numérica
entre plataformas nem escala de produção. Nenhuma auditoria global de anterioridade
foi feita.

## Normalização de signed zero — execução atual

ResolverParams normaliza -0.0 para +0.0 nos thresholds válidos após validação.
A tolerância continua estritamente positiva: +0.0 e -0.0 são inválidos. O exemplo
de teste da revisão que usava tolerância zero e unwrap foi corrigido para usar
uma tolerância positiva nos testes de equivalência.

O perfil passou a resolver-params-ieee754-canonical-zero-v2, domínio
AKG:ONTO:RESOLVER-PARAMS:v2 com NUL final. Isso altera o digest de parâmetros e
do registro mesmo em configurações sem zeros, por versionamento explícito da
regra. O schema/domínio do registro continua v2; parâmetros v1 não são
reinterpretados nem migrados silenciosamente. Ver ADR-0003.

| Comando executado | Resultado |
|---|---|
| python governance/arkhe-governance/tests/fixtures/generate_params_vector.py | PASS: vetores independentes para parâmetros padrão e thresholds zero normalizados |
| cargo test -p arkhe-governance --target-dir target/invariant-resolver-check | PASS: 15 unitários + 19 integração resolver + 8 snapshot + 11 bindings + 2 doctests = 55 |
| cargo test -p arkhe-governance --features duckdb-backend | PASS: 15 unitários + 20 integração resolver + 8 snapshot + 12 bindings + 2 doctests = 57 |
| cargo clippy -p arkhe-governance --all-targets --no-deps --target-dir target/invariant-resolver-check -- -D warnings -A clippy::too_many_arguments | PASS; mesma exceção preexistente |
| rustfmt --check --edition 2021 nos dois arquivos Rust alterados | PASS |

Dois testes novos verificam as quatro combinações de sinal dos thresholds zero
(e refinement=-0.0 com duplicate positivo), igualdade de parâmetros/bytes/digests,
igualdade de contexto e registro, preflight cruzado e rejeição de tolerância zero
sem append. O vetor CBOR independente foi atualizado e o teste confirma separação
do antigo domínio/perfil v1. Os testes de diferenças não nulas exatas continuam
passando, inclusive mudança de um ULP.

Frente B, persistência, replay completo e calibração permanecem pendentes.
