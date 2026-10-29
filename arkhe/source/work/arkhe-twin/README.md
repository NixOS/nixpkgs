# Arkhe Twin — F0–F1

Estado atual: ontologia v5, mapa v3 e perfil offline DSSE/Ed25519/SLSA.
Histórico e limites das versões anteriores estão documentados abaixo.

## Proveniência offline

```powershell
cargo run -p arkhe-twin -- verify-provenance --envelope ./statement.dsse.json --artifact ./artifact.bin --policy ./trust-policy.json
```

`trust-policy.json` é fornecido pelo verificador por canal independente:

```json
{
  "trusted_public_key": "<32 bytes Ed25519 em hexadecimal>",
  "builder_id": "https://ci.example/builder",
  "build_type": "https://ci.example/build/v1",
  "source_uri": "git+https://example/repo",
  "source_digest_algorithm": "gitCommit",
  "source_digest": "<commit de 40 caracteres hex>"
}
```

O comando calcula SHA-256 do arquivo em streaming, verifica a assinatura DSSE
sobre PAE com a chave fixada e confere o Statement in-toto, tipo SLSA, builder,
buildType e dependência fonte. Aceita SHA-1/gitCommit (20 bytes) ou SHA-256
(32 bytes) como identificação da fonte; SHA-1 não é usado para o artefato.
Envelopes são limitados a 4 MiB e 32 assinaturas. `keyid` não estabelece confiança.

Saída não zero rejeita o perfil. Sucesso mantém `skill_status: PENDING` e não
concede nível SLSA nem valida clippy, testes, cobertura, autor humano ou skills.
Não verifica certificados Fulcio, Rekor/SCITT, revogação ou freshness. É um
perfil de chave Ed25519 fixada, não suporte completo a bundles Sigstore.

Veja [pesquisa e fontes oficiais](../../ontology/RESEARCH.md) para as correções
aplicadas à proposta v5. As 49 skills anteriores foram preservadas. Novos
predicados de hardware, SBOM, transparência, computação verificável e agentes
continuam com avaliadores pendentes, explicitamente indicados no catálogo.

Primeira entrega local: `ontology/skills.json` define 49 competências e a CLI
registra um `WorkerExecutionRecord` existente dentro de um envelope Ed25519.
O formato do WER em `arkhe-core` não foi alterado.

## Uso

Forneça `runtime.seed` contendo uma seed Ed25519 de 32 bytes em hexadecimal,
gerada por uma ferramenta criptográfica confiável. Proteja o arquivo com as
permissões do sistema operacional e mantenha-o fora do controle de versão.
A chave pública confiável deve ser distribuída por um canal independente.
A CLI não gera nem publica chaves privadas.

```powershell
cargo run -p arkhe-twin -- record --module rust-axum-api --module-version 1 --key runtime.seed --output ./pr-42.diff --out ./record.json -- cargo test -p arkhe-core
cargo run -p arkhe-twin -- verify-record --record ./record.json --trusted-public-key <chave-publica-hex>
```

O diretório de saída deve existir. O comando nunca sobrescreve registros.
`--input` aceita um artefato opcional; sua ausência usa `Digest32::ZERO`.
Argumentos após `--` são executados diretamente, sem shell implícito.
O comando de teste deve testar o artefato indicado: a CLI não estabelece essa
relação semanticamente. O artefato deve existir antes dos testes e permanecer
igual ao final; uma alteração impede a emissão. Isso não impede alterações
transitórias ou concorrentes por um ambiente hostil.

O envelope inclui horário local UTC, comando, código de saída, hashes dos fluxos
stdout/stderr e chave pública. Todos esses campos e o WER são assinados com
separação de domínio e CBOR determinístico do `arkhe-core`. O WER referencia
o hash do resultado dos testes. Logs e artefatos não são copiados para o registro.
Testes com falha produzem registro assinado com `passed: false` e saída não zero.
`verify-record` autentica também registros de falha; imprime separadamente o
resultado observado dos testes. Ele não reexecuta testes nem verifica competências.

## Limites e próximos passos

A assinatura demonstra posse da chave local e integridade da declaração. O
horário não é um carimbo temporal externo. O signatário pode emitir declarações
falsas: não há atestação de CI, aprovação humana ou garantia de autoria.
O WER usa a operação existente `Execute`; `self_check` é representado por
`test_run.passed` no envelope, sem inventar campos no tipo compartilhado.

A ontologia é uma definição versionada, ainda sem avaliador. Requisitos são
conjuntivos e alegações externas precisam de verificadores confiáveis definidos
pelo consumidor. Nomes de módulos ou comandos não satisfazem essas alegações.
Nenhuma skill recebe automaticamente o estado `CHECKED`.

F2–F7 continuam pendentes: inclusão portátil WormGraph, provas seletivas,
verificador WASM de skills, matching, ZK e vínculo humano. `verify-record` é
somente um verificador nativo do envelope F1. Não há ancoragem da ontologia nem
integração SpecGovernance nesta entrega.

Validação: `cargo test -p arkhe-twin` e `cargo clippy -p arkhe-twin --all-targets -- -D warnings`.

## Fontes Arkhe e importação de CI

`ontology/arkhe-sources.json` mapeia os caminhos encontrados no repositório para
IDs de skill e nomes de módulo aceitos pela ontologia. O mapa identifica alvos
de coleta; não afirma que seus testes passaram. Na versão 4 todas as competências
têm alvo candidato ou planejado, mas nove não têm fonte presente. Componentes de releases ou projetos citados na proposta
não são presumidos integrantes do workspace atual.

```powershell
cargo run -p arkhe-twin -- import-ci --record ./download/record.json --trusted-public-key <chave-publica-do-ci> --expected-module arkhe-kernel --store ./evidence/career
```

`import-ci` aceita o envelope F1 emitido por `record`, verifica a assinatura e o
módulo esperado e preserva os bytes recebidos. O nome do arquivo é derivado do
execution ID; reimportações no mesmo store são rejeitadas, inclusive se houver
outro conteúdo com o mesmo ID. Registros de falha são preservados como falhas.
Logs de CI, WERs sem assinatura e URLs não são convertidos em prova confiável.
A chave confiável é uma escolha do operador; a CLI não prova que ela pertence
ao GitHub ou que a execução aconteceu em um CI independente.

O workflow `.github/workflows/twin-evidence.yml` produz envelopes por execução
manual na branch padrão. Configure `ARKHE_TWIN_CI_SEED` com uma seed Ed25519
dedicada ao CI e distribua sua chave pública por canal independente. O workflow
não foi executado nesta entrega. O produtor e a chave devem ser confiáveis:
código executado no runner pode acessar o ambiente e os arquivos do runner.

O workflow testa a crate escolhida e vincula o registro ao hash de um `git archive`
do commit. O arquivo fonte é o artefato declarado; não é um binário compilado.
O nome do upload contém run ID e tentativa, mas esses nomes não fazem parte da
assinatura do envelope. Não há validação de proveniência SLSA/Sigstore nem
garantia automática de clippy, paridade WASM, RLS ou número de testes. Essas
alegações continuam dependentes de atestações específicas da ontologia.

A versão 4 da ontologia preserva as 15 definições originais e incorpora os
35 predicados da proposta de vagas, reutilizando o ID existente `api-design`:
49 IDs únicos. As famílias são backend, full-stack, dados/ML, segurança,
plataforma, blockchain e a camada transversal AI-native.

Todas as definições têm `evidence_status: PENDING`, pois nenhum conjunto de WERs
foi avaliado contra seus requisitos e uma política de confiança. Isso não afirma
que o repositório não contém evidências; informa que elas não foram validadas
por este catálogo. Existência de código, documentação, manifesto ou assinatura
local não concede `CHECKED`.

Os requisitos indicam resultados concretos esperados, como rejeição de nonce
reutilizado em TEE, recuperação de outbox, avaliação ML com dataset versionado,
ou testes negativos de assinatura de carteira. São definições para um futuro
avaliador, não implementações de verificadores dessas alegações. dbt, Kubernetes,
wallets e outras fontes não encontradas permanecem sem mapeamento confirmado.

`communication`, `ownership`, `systems-thinking` e `prompt-engineering` limitam
sua afirmação à existência de artefatos, aprovações, avaliações ou revisões
atestadas. Não demonstram uma qualidade humana nem autoria exclusiva. Um
reviewer confiável ainda pode errar; a assinatura autentica sua declaração.

As tecnologias listadas nas vagas não são equivalentes: Ed25519 não comprova
ZK/SMPC; migrações SQL não comprovam Terraform; inferência não comprova treino
de modelos. A definição `ml-lifecycle` exige uma execução de treino/fine-tuning
além da avaliação. A taxonomia veio do texto fornecido; estatísticas de mercado
e demanda em 2026 não foram verificadas nesta alteração.

Contagens e janelas temporais são políticas propostas. IDs relacionados, como
`merkle-proofs` e `merkle-proofs-blockchain`, não implicam um ao outro. O
avaliador de skills, `prove` e provas seletivas continuam pendentes.

## Ontologia v4 e source-map v2

A versão 4 refina as 16 definições destacadas na proposta sem remover as outras
33. Todas as 49 seguem `PENDING`. O mapa v2 contém 58 associações: 41 para
caminhos presentes e 17 para caminhos planejados ausentes no checkout.
`unmapped_skills: []` significa cobertura de planejamento; a lista separada
`skills_without_present_source` contém as nove competências sem fonte presente.

Os caminhos propostos são conferidos no filesystem. Um caminho ausente não é
criado artificialmente para aparentar implementação. `record_module` é um rótulo
de coleta compatível com o prefixo do predicado, não prova de que aquela fonte
já emite WERs. Propostas incompatíveis são registradas em `proposed_module`.

O `attestation_contract` especifica o vínculo exigido entre claim, execution ID,
output, snapshot de código, commit, comando, resultado, hashes de logs/relatório,
horário e signatário. Cobertura exige relatório com ferramenta, escopo, contagens
e limiar explícito; `cargo test` sozinho não comprova cobertura. O contrato ainda
não tem produtor ou avaliador implementado. O envelope F1 existente não passa
a representar automaticamente uma atestação externa. A verificação de skills
não foi integrada ao `ContainmentGate`.

Consumidores devem identificar a definição pela versão e pelo hash de conteúdo
da ontologia, além do skill ID: requisitos foram refinados mantendo os IDs.

```powershell
cargo test -p arkhe-twin --test stencil
```

Esse alvo valida consistência de versões, cobertura do catálogo, presença real
dos caminhos, estados candidato/planejado, prefixos e contrato de atestação.
Casos negativos rejeitam presença falsa, módulo incompatível, alvo removido,
path fora do repositório, confiança desabilitada e `CHECKED` sem avaliação.
Não é um verificador de competência, assinatura humana ou prova Merkle.
