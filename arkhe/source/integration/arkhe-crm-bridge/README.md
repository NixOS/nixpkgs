# Arkhe CRM Bridge — protocolo v2

CLI local com contrato canônico versionado, assinatura Ed25519 do produtor,
autorização por organização/origem/objeto/campo, checkpoints assinados e
armazenamento transacional SQLite com controle de replay. Reutiliza o MMR de
`arkhe-verify-core`. O CLI não expõe servidor HTTP. Há um entregador REST
exclusivo para sandbox com intenção de escrita assinada e reconciliação, mas
nenhum acesso ao Salesforce foi executado nesta entrega. Um
[candidato Apex para sandbox](salesforce/README.md) está preparado, sem deploy
ou execução de testes na plataforma.

[Integração, CI, outbox e recuperação](salesforce/docs/OPERATIONS.md) descreve
os comandos `sign-write`/`prepare-write`, autenticação JWT e o repositório dedicado.

## Executar

Na raiz do workspace, com PowerShell 7 e Rust:

```powershell
& ./integration/arkhe-crm-bridge/scripts/demo.ps1
cargo test -p arkhe-crm-bridge-cli
cargo clippy -p arkhe-crm-bridge-cli --all-targets --no-deps -- -D warnings
```

A demo cria um diretório temporário com chaves aleatórias de produtor e Bridge,
política, evento, requisição assinada, banco e prova. Executa assinatura,
ancoragem, verificação offline, repetição exata e exportação, comparando as
respostas. As chaves geradas são de demonstração. O CLI pode ser usado assim:

```powershell
# Diretório de trabalho separado, com política e evento v2 preparados.
arkhe-crm-bridge-cli keygen --secret producer.key
arkhe-crm-bridge-cli keygen --secret bridge.key
arkhe-crm-bridge-cli sign --input event.json --secret producer.key > request.json
arkhe-crm-bridge-cli anchor --input request.json --database bridge.db --policy policy.json --secret bridge.key > proof.json
arkhe-crm-bridge-cli verify --proof proof.json --policy policy.json
arkhe-crm-bridge-cli export --event-id evt-1 --database bridge.db --policy policy.json > recovered.json
```

`keygen` imprime a chave pública e recusa sobrescrever arquivos. A política
contém chaves públicas e concessões; deve ser distribuída por canal confiável.
Em operação real, produtor e Bridge possuem chaves privadas distintas em
processos separados. Consulte a demo para construir a política e os timestamps
de emissão/expiração; a fixture v2 usa tempos fixos somente para testes.

## Comportamento

- JSON serve como transporte; assinaturas usam bytes binários canônicos v2.
- Somente produtores cadastrados e campos explicitamente concedidos são aceitos.
- Checkpoint vincula log, raiz, tamanho, política, horário e checkpoint anterior.
- Evento, chave de replay e resposta são gravados numa única transação SQLite.
- Retry idêntico recupera a resposta original; conteúdo diferente com o mesmo
  event_id é rejeitado. `export` recupera resposta após falha de entrega.
- Verificação offline valida evidência histórica na data do checkpoint; não
  constitui autorização para executar uma nova escrita no CRM.

## Documentação e limites

[Contrato e modelo de confiança](docs/PROTOCOL-V2.md) especifica bytes, assinaturas,
escopos, validade e replay. [Desenho do gate Salesforce](docs/SALESFORCE-GATE-DESIGN.md)
documenta aprovação prévia e a matriz de validação necessária em sandbox.

As provas autenticam declarações de chaves autorizadas; não demonstram que o
valor seja verdadeiro. Um bundle isolado não garante completude, ausência de
fork ou checkpoint mais recente. Rollback completo do banco exige uma
testemunha externa para detecção e recuperação seguras; ainda não implementada.
Rotação/revogação e migração de políticas também exigem trabalho adicional.

Histórico é revalidado por reconstrução dos prefixos MMR a cada inserção, com
custo quadrático; apropriado para validação local e pilotos pequenos. Chaves
em arquivo e dados em texto claro não são um serviço de custódia ou criptografia
em repouso. No Windows, use diretórios com ACLs restritas para segredos.

## Evidência local

Testes cobrem vetores congelados, adulteração de campos assinados, autorização,
validade, replay conflitante, recuperação após reabrir banco, rollback com
falha SQL injetada, concorrência de retries e corrupção do histórico. A demo
executa os comandos reais. Nenhum teste ou deploy Salesforce foi realizado.

Os formatos v1 e v2 são incompatíveis. A biblioteca mantém o protótipo v1 para
referência; o CLI não aceita sua prova nem importa automaticamente seu diário.
