# ADR-0003 — Seis bindings de auditoria no registro de resolução

Status: Frente A implementada. Perfil do grafo completo (Frente B), armazenamento
durável e executor de replay continuam pendentes. Este ADR sucede as pendências
de bindings descritas no ADR-0002; não altera seu perfil de snapshot.

## Contrato

ResolutionRecord ganha `context: ResolutionContext`, que contém os seis digests,
os parâmetros efetivos e seletores de versões tipados. ResolverError::LogFailure
ganha o mesmo contexto em Box, além do veredicto opaco, reason e partial_digest.
O contexto é calculado antes de qualquer decisão e preservado sem alteração em
todos os caminhos: conflito, novel sem comparáveis, cold start e scoring.

ResolverParams valida os quatro parâmetros. O resolver atual não aceita prior
configurável; a inicialização do EM pertence ao perfil AlgorithmVersion.

| Binding em context.bindings | Tipo / origem | Domínio BLAKE3 |
|---|---|---|
| snapshot | OntologyVersion; conteúdo do snapshot de invariantes | AKG:ONTO:INVARIANT-SNAPSHOT:v1 |
| candidate | Digest32; Invariant::object_digest | AKG:ONTO:INVARIANT:v1 |
| corpus | Digest32; membros elegíveis após filtro e exclusão por ID | AKG:ONTO:TRAINING-CORPUS:v1 |
| params | ParamsDigest; parâmetros validados e canônicos | AKG:ONTO:RESOLVER-PARAMS:v2 |
| algorithm | Digest32; descritor de AlgorithmVersion | AKG:ONTO:RESOLVER-ALGORITHM:v1 |
| comparison | Digest32; descritor de ComparisonVersion | AKG:ONTO:RESOLVER-COMPARISON:v1 |

Todos os domínios da tabela terminam em byte NUL. Os três últimos digests são
derivados de CBOR canônico usando o encoder AKG-CBOR-v1 existente.

O corpus é o conjunto ordenado elegível para treino. Em conflito/cold start/novel,
esse binding não afirma que EM foi executado; a tag do registro distingue o fluxo.
O snapshot cobre todos os existentes fornecidos, inclusive ações que não entram
no corpus e registros do mesmo ID do candidato excluídos da comparação.

## Parâmetros e versões

ResolverParams possui campos privados e construtor validado: limites finitos,
0 <= refinement <= duplicate <= 1, iterações positivas representáveis em uint64,
tolerância finita positiva. Getters permitem recuperar os valores exatos.

A exigência de tolerância positiva é uma decisão de contrato: habilita o critério
`max_delta < tolerance`, sem garantir que ele será satisfeito antes do limite de
iterações. Tolerância zero desabilitaria esse critério, mas não tornaria o loop
ilimitado. fit_em também retorna para corpus vazio e pode interromper por massa
posterior quase nula. A rejeição de zero não demonstra instabilidade do modelo.

No CBOR, floats são representados por seus bits IEEE-754 como uint64, com o perfil
`resolver-params-ieee754-canonical-zero-v2`. Isso evita floats JSON e não depende
de escolha de precisão decimal. No construtor, signed zero dos thresholds é
canonicalizado para zero positivo após a validação. Os demais valores aceitos
preservam os bits exatos. A tolerância deve continuar estritamente positiva:
tanto 0.0 quanto -0.0 são rejeitados, antes de construir os parâmetros.

O perfil anterior `resolver-params-ieee754-bits-v1`, domínio
`AKG:ONTO:RESOLVER-PARAMS:v1\0`, preservava signed zero. A mudança de regra usa
perfil/domínio v2 para não reinterpretar registros anteriores. Isso altera o
digest de parâmetros de todas as configurações, inclusive sem zeros, e por
consequência os digests dos registros que os contêm. O schema/domínio do registro
continua v2: sua forma não mudou e a projeção de params identifica o novo perfil.
Não há conversão silenciosa de bindings antigos; comparação/replay de dados do
perfil anterior exigirá suporte explícito a esse legado.

Mudar perfil e domínio juntos é a convenção adotada, não uma necessidade de
alterar ambos. O perfil está na projeção CBOR e o domínio prefixa o hash; mudar
qualquer um altera sua entrada, com distinção de digests sujeita à hipótese usual
de resistência a colisões. Não são duas autenticações independentes. O digest
sozinho não revela o domínio: o verificador precisa conhecer a regra e recomputá-lo.

## Formatos anteriores e suporte histórico condicional

Os formatos desenvolvidos devem ser distinguidos sem presumir que existem dados
persistidos de cada etapa:

| Formato | Contexto de auditoria | Tratamento se houver dados a verificar |
|---|---|---|
| Anterior aos bindings, com digest de registro v1 | Sem os seis bindings | Possível auditoria limitada dos campos/hash se conteúdo e regra originais estiverem disponíveis; os bindings ausentes não são reconstruídos pelo registro sozinho |
| Registro v2 com perfil de parâmetros v1 | Seis bindings; signed zero preservado nos parâmetros | Verificação histórica precisa reconhecer e recomputar o perfil/domínio de parâmetros v1 |
| Registro v2 com perfil de parâmetros v2 | Seis bindings; thresholds zero normalizados | Verificação de inputs pelo contrato atual |

“Perfil de parâmetros v1” não significa “schema do registro v1”. A existência
de formatos no histórico de desenvolvimento não prova a existência de coortes
de registros armazenados. Sem dados históricos a consumir, um adaptador legado
não é uma obrigação de implementação. Nenhum adaptador foi implementado aqui.

Registros sem contexto não são necessariamente inúteis para auditoria nem ficam
restritos a arquivamento: seus campos e eventual âncora externa podem sustentar
verificações limitadas. Isso não fornece os seis bindings ou replay completo.

## Descritores tipados de execução

AlgorithmVersion é enum fechado, atualmente FellegiSunterEmV1, com tag
`fellegi-sunter-em-v1@0.1.0`. Seu descritor inclui inicialização m/u/prior, número
de atributos e identificadores das regras EM, weak permission, cold start e
desempate. Os testes vinculam a inicialização declarada ao default_model atual.

ComparisonVersion é enum fechado, atualmente AsciiExactV1, com tag
`ascii-condition-modality-action-blocking-v1@0.1.0`. Seu descritor inclui seleção
do corpus, todos os pares não ordenados por ação normalizada ASCII e os atributos
binários condition/modality. A versão descreve blocking e comparação juntos.

Tags/descritores são contratos versionados, não hashes do código-fonte ou do
executável. Mudanças de implementação que alterem semântica exigem nova versão.
Os enums não aceitam strings livres como identidade de execução.

## Backends e compatibilidade

ErBackend::comparison_version retorna None por padrão. InMemoryBackend e
DuckDbBackend declaram AsciiExactV1; testes comparam também os seis bindings e os
bytes do registro entre ambos. Backends customizados precisam declarar uma versão
suportada explicitamente. Sem declaração, resolve e preflight retornam InvalidInput
antes de blocking, comparação, EM ou append, mesmo no caminho sem comparáveis.

Essa declaração é uma fronteira de confiança: um backend pode mentir sobre suas
regras. Os bindings não provam conformidade do código à versão declarada nem
capturam estado oculto de uma implementação customizada.

`resolve(candidate, existing)` mantém a assinatura, constrói um OntologySnapshot
validado e chama resolve_snapshot. Assim, ambos os caminhos produzem o mesmo
contexto e registro para o mesmo conteúdo, independentemente da ordem de entrada.
Existe custo adicional de cópia/hash nessa entrada; snapshots podem ser reutilizados.

O schema público mudou: consumidores que constroem ResolutionRecord por literal
precisam fornecer context; matches exaustivos de LogFailure precisam tratar seu
novo campo (ou usar `..`). Backends existentes continuam compilando pelo método
default, mas precisam migrar a declaração para continuar resolvendo.

## Registro v2 e falha do log

CanonicalEncode para ResolutionRecord usa domínio `AKG:ONTO:RESOLUTION:v2\0`.
O CBOR contém schema, os seis digests, params completos, tags tipadas, candidate_id,
existing_id (byte string ou null), verdict_kind e match_probability_bits (uint64).
Os digests e IDs são byte strings CBOR de 32 bytes. Nenhum campo público atual
do registro fica fora do digest. O domínio v1 anterior não é reinterpretado.

partial_digest é o object_digest v2 calculado antes de append. Se append falhar,
LogFailure conserva o mesmo ResolutionContext e os parâmetros, sem expor um
ResolutionVerdict acionável. MockResolutionLog usa o mesmo digest v2. O digest
retornado por outro logger pode ser uma âncora própria, distinta desse object_digest.

Inputs inválidos ou backend sem versão não produzem um registro de decisão e
não são LogFailure. Um erro retornado também não constitui persistência de uma
tentativa: o chamador precisa guardar o diagnóstico se precisar auditá-lo depois.

## Verificação anterior à execução

`verify_record_inputs(record, candidate, snapshot)` compara o candidate_id e
recalcula os seis bindings com os inputs/configuração efetivos do resolver.
ResolutionContext::verify também compara os parâmetros anexados e as versões
com os dados recomputados. Retorna BindingMismatch com a dimensão divergente.

A verificação não chama candidate_pairs, comparison_vector, EM, scoring ou append.
Ela é uma operação explícita: não existe executor que automaticamente faça essa
checagem e depois reexecute/compare a decisão. Ela não autentica o registro e não
valida sua saída, seu score ou seu veredicto. Um atacante que substitua inputs,
contexto e digests conjuntamente não é detectado sem uma âncora confiável.

ResolutionContext tem campos públicos para representar afirmações carregadas;
isso não as torna verificadas por construção. A aplicação deve verificar antes
de consumi-las e preservar os artefatos correspondentes.

## Limites e próximos trabalhos

Os seis bindings tornam explícitos os inputs de auditoria, mas não garantem
replay por si sós. Faltam reader, retenção/content store, versões executáveis
preservadas, política numérica por plataforma e um executor que verifique inputs
antes de rodar e compare o resultado. O log continua em memória; não há WORM,
assinatura ou transação com mutações no grafo. Calibração continua não demonstrada.

Frente B segue separada: arestas/cobertura tipadas e um perfil próprio do grafo
completo ainda não existem. A Frente A não altera o escopo do OntologySnapshot.
Não se afirma que este seja o primeiro artefato do Arkhe com qualquer propriedade:
nenhuma auditoria global foi realizada.

## Testes

Casos cobrem todos os caminhos de decisão, seis adulterações independentes,
alteração dos inputs/configuração/payload, declaração ausente do backend,
identidade do registro nas duas entradas, binding de todos os campos do registro,
parâmetros exatos com vetor CBOR Python independente e descritor do modelo.
O teste de falha de log existente verifica igualdade integral do contexto em todos
os caminhos que exercita. Com DuckDB, há paridade do contexto e bytes v2.
Comandos e contagens efetivos estão em TEST-RESULTS.md.
