# ADR-0002 — Identidade de snapshot imutável de invariantes

Status: implementado para o perfil de invariantes; replay completo e snapshot de
ConstitutionGraph com arestas/cobertura continuam pendentes.

Atualização: ADR-0003-resolution-bindings.md implementou posteriormente os seis
bindings, os parâmetros e as versões no registro/LogFailure. Este documento
preserva a descrição do perfil de snapshot e registra essa evolução abaixo.

## Escopo e decisão

O anexo propõe definir um OntologySnapshot canônico antes de acrescentar seis
bindings ao ResolutionRecord. A etapa original deste ADR implementou essa base;
o ADR-0003 alterou posteriormente o schema do log, mantendo resolve(candidate, existing).
Há uma entrada adicional
resolve_snapshot(candidate, &OntologySnapshot), que usa o contrato atual.

Não existe um ConstitutionGraph com arestas/cobertura tipadas no módulo atual.
Por isso, o perfil `arkhe-invariant-snapshot-v1` identifica exatamente uma coleção
de invariantes. Ele não se apresenta como digest de um grafo completo, e não
serializa arestas/cobertura ausentes como se fossem conjuntos vazios conhecidos.
Um perfil futuro do grafo deve definir esses tipos e usar outro schema/domínio.

## Tipos e invariantes de construção

- OntologySnapshot possui Vec<Invariant> e OntologyVersion privados. new consome
  o vetor, ordena por bytes do ID e rejeita IDs repetidos, mesmo com conteúdo igual.
  O acesso é somente por referência compartilhada. Não há setter ou deserialização
  derivada que permita atribuir uma versão sem recomputar o conteúdo.
- OntologyVersion encapsula Digest32. from_bytes importa uma identidade declarada,
  não verifica conteúdo. from_verified_invariants reconstrói o snapshot e compara
  a versão esperada; divergência retorna SnapshotError::VersionMismatch.
- Invariant mantém seus campos públicos para uso normal; o snapshot possui seus
  próprios valores. Alterar o vetor original ou uma cópia não altera o snapshot.
- O ID armazenado é um identificador do domínio, não necessariamente um hash do
  conteúdo. A identidade do snapshot vincula tanto esse ID quanto todos os campos.

## Formato canônico

Usa o encoder AKG-CBOR-v1 já existente em arkhe-core::canonical, sem nova
dependência de serialização. Mapas seguem a ordem dos bytes das chaves codificadas;
comprimentos são definidos, inteiros usam a menor largura e texto UTF-8 é preservado.

Projeção do snapshot:

```text
{
  "profile": "arkhe-invariant-snapshot-v1",
  "invariants": [invariante em ordem crescente de ID, ...]
}
```

Cada invariante contém seis campos: hash (InvariantId como byte string CBOR de 32
bytes), modality (obligatory/optional/impermissible), action, condition, specificity
e enacted_at. Não há floats no perfil. O nome wire `hash` permite usar
a representação de digest em bytes do encoder existente; não afirma que o ID foi
calculado a partir dos demais campos.

Version = BLAKE3(`AKG:ONTO:INVARIANT-SNAPSHOT:v1\0` || CBOR da projeção).
Invariant::object_digest usa domínio separado `AKG:ONTO:INVARIANT:v1\0` e a
projeção completa do candidato, oferecendo a base para seu binding futuro.

A ordem fornecida pelo chamador não altera bytes/versão. Alterações de conteúdo,
incluindo apenas caixa do texto, especificidade ou data, alteram a entrada do hash.
Igualdade de comparação ASCII não implica identidade de conteúdo. Não há
normalização Unicode ou de expressões. A ausência de colisões é uma hipótese
criptográfica; nenhum digest finito garante injetividade matemática.

## Corpus e ordem do EM: correção da revisão recebida

O resolver anterior já executava:

1. Exclusão por candidate.id e ordenação de todos os existentes por ID.
2. Filtro same_action preservando essa ordem.
3. Construção de training_corpus a partir dessa sequência.
4. Ordenação/deduplicação dos pares antes de gerar training_vectors.

Logo, não havia a lacuna alegada de corpus não ordenado antes do EM.
O novo teste compara também posterior em bits entre uma resolução por snapshot
e outra por slice invertido, em resolvers distintos com caches inicialmente vazios.
Isso verifica o ambiente/build local; não prova equivalência bit a bit entre
arquiteturas, toolchains ou versões diferentes de backend.

OntologySnapshot::training_corpus deriva referências ordenadas com o mesmo filtro
ASCII e exclusão por ID. corpus_digest vincula a projeção dos membros selecionados
e a seleção `same-action-ascii-exclude-candidate-id-v1`, com domínio separado
`AKG:ONTO:TRAINING-CORPUS:v1\0`. Não é a chave interna do cache de vetores FS.

O candidato é um input separado: alterar campos de scoring sem alterar a seleção
pode preservar o digest do corpus, mas altera o digest do candidato. Acrescentar
um invariante de outra ação pode alterar o snapshot sem alterar o corpus.

## Seis dimensões e o que ainda falta

| Dimensão proposta | Estado após este incremento |
|---|---|
| Snapshot digest | Implementado para o perfil de invariantes; grafo completo pendente |
| Candidate digest | Disponível por Invariant::object_digest, sobre CBOR canônico |
| Corpus digest | Disponível com filtro versionado e ordem estável |
| Params digest | Implementado no ADR-0003; parâmetros exatos também anexados ao registro |
| Algorithm version | Enum versionado e digest de descritor no registro, conforme ADR-0003 |
| Comparison version | Enum versionado para blocking/comparação e digest no registro, conforme ADR-0003 |

ResolutionRecord e ResolverError::LogFailure receberam esses bindings no ADR-0003.
reason e partial_digest pertencem ao erro LogFailure, não ao ResolutionRecord.
O registro atual ainda não basta para replay sem artefatos preservados e executor.

As seis dimensões são um desenho útil de auditoria, não uma prova automática de
reprodutibilidade. O corpus é derivável do snapshot, candidato e seleção fixados;
seu digest explícito é uma checagem redundante útil, não necessariamente um input
independente. Tags/semver exigem artefatos executáveis preservados e semântica
controlada. Estado do backend, dependências e ambiente numérico também precisam
de uma política de replay. Modelos/custom backends não são fixados por este módulo.

Não há reader de CBOR, armazenamento content-addressed, retenção de snapshots,
assinatura, logger durável ou executor de replay. A API de carga recebe conteúdo
tipado e verifica sua versão; armazenar/recuperar os bytes continua sendo trabalho
de integração. Nenhuma mesclagem do grafo é executada.

## Validação

Oito testes de integração cobrem permutação, todos os campos do invariante,
duplicação de IDs, verificação de versão, isolamento de mutações, corpus derivado,
vetores CBOR independentes e equivalência do adapter. Um doctest compile_fail
confirma que a coleção exposta não pode ser alterada.

tests/fixtures/generate_snapshot_vectors.py gera vetores com um encoder Python
independente, usando somente a biblioteca padrão. Casos: snapshot vazio e registro
com ID byte string, UTF-8 e limites de u32/u64. A comparação dos bytes não usa o
encoder Rust para construir o valor esperado.

Resultados executados estão em TEST-RESULTS.md.
