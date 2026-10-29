# ADR-0001 — InvariantResolver

Status: implementação local; adequação a produção depende de validação empírica e integração.

Incremento posterior: ADR-0002-ontology-snapshot.md define um snapshot imutável
content-addressed do perfil de invariantes e a entrada adicional resolve_snapshot.
ADR-0003-resolution-bindings.md acrescenta os seis bindings ao registro e ao
LogFailure; o executor de replay completo permanece pendente.

## Contrato implementado

`InvariantResolver::resolve(candidate, existing)` produz Duplicate, CandidateRefines,
ExistingRefines, Conflict ou Novel. O módulo foi acrescentado ao crate existente,
preservando PolicyResolver, authenticated e policy_bundle. constitution_graph.rs
contém somente InvariantId e Modality: não implementa um banco de grafos.

1. Valida thresholds finitos, 0 <= refinement <= duplicate <= 1, iterações > 0,
   tolerância finita positiva e unicidade dos IDs existentes.
2. Exclui do universo de resolução qualquer registro com o ID do candidato.
   Ordena existentes por ID para desempate estável, inclusive conflitos.
   Conflict reporta um testemunho de conflito: o menor ID é uma escolha arbitrária
   e estável, sem prioridade semântica. O retorno e o registro não enumeram todos
   os conflitos; consumidores que precisem resolvê-los em conjunto exigirão outro
   contrato. enacted_at e specificity não definem qual conflito é reportado.
3. Detecta conflitos antes do cold start, por igualdade ASCII sem distinção de
   caixa de action e condition. Weak permission: Impermissible contradiz Optional
   e Obligatory; Optional e Obligatory são compatíveis. Não detecta sobreposição
   lógica de condições distintas.
4. Filtra same_action antes de treinar e pontuar. ACTION é chave de blocking;
   os únicos atributos FS são condition e modality (FS_ATTRIBUTES = 2).
5. Corpus de treino contém apenas existentes da mesma ação, nunca o candidato.
   A ordenação por ID do passo 2 é preservada pelo filtro e pela construção do
   corpus; os pares também são ordenados antes de gerar vetores para o EM.
6. Zero pares implica retorno Novel antes de criar/ajustar o modelo, mesmo com
   thresholds zero. Log: novel_cold_start, referência ao comparável e probabilidade
   zero como sentinela de ausência de evidência. Sem comparáveis: novel e None.
7. Ajusta EM com suavização e pontua somente comparáveis. O maior posterior vence;
   empates escolhem o menor ID. Os thresholds padrão permanecem 0.85 e 0.70.
   Acima de 0.85: especificidade igual dá Duplicate; maior/menor dá refinamento.
   Entre 0.70 e 0.85: apenas especificidades diferentes dão refinamento.
8. Só retorna Ok após append confirmado. Falha preserva reason e partial_digest
   calculado antes do append, com ComputedVerdict opaco inclusive em Debug.
   Registro e LogFailure preservam o mesmo contexto com seis bindings e os
   parâmetros/versões efetivos. Backends precisam declarar uma versão suportada.
   InvalidInput não produz registro de decisão.

## Correções da especificação fornecida

- FellegiSunter precisava de Clone. Derives de ResolverError exigiam características
  ausentes no wrapper. Debug automático no wrapper revelaria o veredicto interno.
- ResolutionLog::append retorna Result<Digest, String>: o logger pode sinalizar
  falha sem construir um ComputedVerdict cujo construtor é privado. O resolver
  cria LogFailure e preserva a causa original.
- Cache de blocking agora é usado. Guarda pares de InvariantId, remapeados para
  índices; chave inclui IDs e ações normalizadas. Ordenação estabiliza o corpus.
  Mudança de membros/ações invalida; mudança de condition/modality recalcula vetores
  e invalida o modelo quando altera as evidências. Ambos os caches são limitados
  à última entrada. Modelo inclui corpus, max_em_iterations e em_tolerance.
- DuckDB usa Mutex<Connection> persistente, serializando limpeza/inserção/join.
  A tabela é limpa, não recriada, por chamada. Normalização é ASCII em ambos os
  backends, coerente com eq_ignore_ascii_case; não é normalização Unicode/NLP.
- A versão inicial do hash usava discriminante de Option e comprimento da tag.
  O registro atual usa CBOR tipado no domínio v2, incluindo os seis bindings
  (ADR-0003). Não é uma cadeia de hashes ou prova de persistência.
- Os três testes positivos de corpora minúsculos do anexo retornavam Novel com
  seu próprio algoritmo. Foram preservados como regressão; casos positivos usam
  corpus sintético com evidência suficiente, sem reduzir thresholds.
- P(match | gamma=[1,1]) no modelo inicial é 9/14 = 0.642857; com prior 0.3 é
  243/278 = 0.874101, acima de 0.85. Ambos são verificados por teste.
  O segundo valor é um cenário contrafactual no modelo FellegiSunter: o resolver
  atual cria default_model internamente e não expõe configuração de prior.
  O early-return garante ausência de scoring no cold start independentemente de
  mudanças futuras no prior. O teste com thresholds zero verifica essa propriedade
  no resolver; os testes numéricos verificam separadamente a álgebra do modelo.

## Limites estatísticos e semânticos

Dois atributos binários oferecem três graus de liberdade observáveis, enquanto
uma mistura irrestrita de duas Bernoulli independentes tem cinco parâmetros.
Assim, EM não identifica em geral uma solução única nem garante calibração,
orientação dos componentes, precisão ou recall. Um par de treino habilita o
fluxo, mas não prova confiabilidade. Suavização influencia fortemente corpus pequeno.
É necessário validar com pares rotulados e medir erros por ação antes de automatizar
mesclagens. Os posteriors devem ser tratados como scores operacionais provisórios.

A não-identificabilidade não demonstra, isoladamente, a causa dos três resultados
Novel nem impõe um teto universal de posterior. O fato observado é específico:
com aqueles corpora, inicialização, suavização, critérios de parada e thresholds,
o algoritmo retorna Novel. Atribuir esses resultados exclusivamente à
não-identificabilidade, ou afirmar um teto geral de aproximadamente 0.17, exigiria
uma derivação adicional que os testes executados não fornecem.

Uma action constante no bloco não informa distinção intra-bloco; removê-la é
adequado aqui. A desigualdade m < u sob suavização depende das massas posteriores;
não constitui teorema universal sobre qualquer execução de EM.

Specificity é metadado informado pelo chamador; CandidateRefines/ExistingRefines
são classificações heurísticas, sem prova de subsunção de condições. enacted_at
é preservado, mas não governa desempate ou precedência temporal.

Novel no cold start impede mesclagem automática sem evidência; não é autorização
para executar uma ação nem decisão de conformidade. A aplicação decide inserção,
revisão e reavaliação posterior. O resolver não altera o grafo.

ComputedVerdict impede acesso tipado acidental ao resultado não registrado.
Seu digest deriva de apenas cinco tags e pode ser enumerado; não garante sigilo
nem impede que código chamador ignore Err. O logger é uma fronteira de confiança.
MockResolutionLog é um coletor append-only em memória para testes, sem fsync,
WORM, encadeamento, retries ou transação atômica com mutações do grafo.

## Escala e operação

Blocking custa O(n + soma dos tamanhos de bloco ao quadrado) para materializar
pares. Como o treino já filtra uma ação, seu pior caso é O(k²) em memória e tempo.
DuckDB também materializa o resultado em Vec e não elimina esse limite. Backend é
um protótipo, não evidência de escala de produção. Seu contrato exige índices
válidos, pares únicos e comparações binárias; falhas de SQL/locks ainda podem
causar panic. Limites de blocos, amostragem, API falível e benchmarks são trabalho
futuro. Backends devem ter semântica estável enquanto o resolver os utiliza.

## Verificação

Ver TEST-RESULTS.md para comandos e resultados efetivamente executados. A suíte
cobre os cinco veredictos, nove combinações de modalidade, isolamento de ação e
candidato, cold start independente de thresholds, logs com falha, caches,
estabilidade numérica, encapsulamento por compile_fail e paridade DuckDB.

## Exemplo de uso

```rust
use arkhe_governance::{
    constitution_graph::Modality,
    er_backend::{InMemoryBackend, Invariant},
    invariant_resolver::{InvariantResolver, MockResolutionLog, ResolutionVerdict},
};

let resolver = InvariantResolver::new(
    Box::new(InMemoryBackend),
    Box::new(MockResolutionLog::new()), // somente desenvolvimento/testes
);
let candidate = Invariant {
    id: [1; 32], modality: Modality::Obligatory,
    action: "pay".into(), condition: "amount>1000".into(),
    specificity: 5, enacted_at: 1,
};
assert_eq!(resolver.resolve(&candidate, &[]).unwrap(), ResolutionVerdict::Novel);
```

Substituir MockResolutionLog por um adaptador durável antes de usar decisões
em produção. O adaptador implementa append(&ResolutionRecord) -> Result<[u8;32],
String>; a aplicação deve tratar Err sem aplicar mudanças no grafo.
