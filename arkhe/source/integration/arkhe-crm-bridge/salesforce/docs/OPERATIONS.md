# Salesforce Arkhe — operação e critérios de liberação

Estado em 25/10/2026: implementação local e pipeline preparados; nenhuma org,
credencial, agenda Apex ou implantação remota foi provisionada por esta entrega.
O diretório dedicado gerado tem `sfdx-project.json` na raiz e inclui `native/`
com apenas as três crates necessárias ao verificador. O snapshot original no
Arkhe não deve ser promovido por um segundo pipeline concorrente.

## Ambientes e GitHub

QA de integração: Full Sandbox, ou Partial Copy com dados representativos e
anonimizados. Inventariar data do refresh, versão de API, Flows/triggers,
picklists, validações e perfis. O tipo da sandbox não é inferido por seu alias:
`Organization.IsSandbox` é conferido antes de qualquer escrita. Sandbox não é
um substituto de evidência de operação produtiva.

Criar o repositório privado `salesforce-arkhe-integration` no proprietário real
da equipe e conectar o repositório local. Não há remote fictício configurado.
Proteger `main`, exigir revisão, CI offline e job sandbox; restringir alterações
de `.github/workflows` a mantenedores. Não conceder secrets a código de forks.

Configurar três GitHub Environments:

| Environment | Uso | Proteção |
|---|---|---|
| `validation-qa` | Check-only e testes contra QA | Acesso apenas a colaboradores confiáveis; principal dedicado |
| `integration-qa` | Deploy manual após merge | Required reviewers e branches de deploy restritas a main |
| `production` | Validação e quick deploy do mesmo job | Required reviewers, main e aceite operacional do commit |

Em cada environment: secrets `SF_JWT_KEY`, `SF_CLIENT_ID`, `SF_USERNAME`; variável
`SF_INSTANCE_URL` com URL HTTPS explícita da org. Configurar aplicação OAuth
compatível com JWT bearer, certificado público e usuário preautorizado na org.
A chave privada fica exclusivamente no secret do runner/cofre, com rotação e
revogação ensaiadas. O runner usa chave temporária com permissão 0600 e apaga
o diretório no encerramento normal. Não usar o usuário administrativo pessoal.

O workflow de promoção verifica pela API do GitHub a existência de reviewers
obrigatórios e um job QA bem-sucedido para o SHA exato de `main`. A disponibilidade
dessas proteções depende do plano/configuração GitHub: se a API não comprovar
proteção, a promoção falha. O YAML sozinho não cria Environment nem proteção.
Produção também exige `SF_PRODUCTION_ACCEPTED_COMMIT` igual ao SHA revisado.
Não configurar esse aceite antes dos ensaios operacionais abaixo.

`salesforce-ci.yml`: parser Apex, XML estrutural, testes Python/Rust, Clippy e
check-only QA com RunLocalTests. `salesforce-promote.yml`: acionamento manual,
backup de metadados, nova validação, cobertura por componente e deploy do
mesmo conteúdo. Sandbox usa `project deploy start --dry-run`; produção usa
`project deploy validate` e `quick` com o ID retornado. Jobs pendentes e cobertura
ausente não são aprovados. Não executar testes e probes de concorrência juntos.

## Escrita Rust → Salesforce

O produtor captura `SystemModstamp` do Lead via REST e assina uma intenção
adicional; não há alteração do contrato v2 ou dos vetores congelados.
Os bytes da intenção são os quatro textos enquadrados por u64be(length)||UTF-8:
domínio `arkhe.crm.salesforce.write.v1`, hash canônico do evento v2, hash do
checkpoint v2 e versão esperada em UTC com três casas de milissegundos e `Z`.
A assinatura Ed25519 pertence ao mesmo produtor autorizado pelo evento.
O hash da intenção é persistido em `Request_Hash__c`; não é o hash do JSON.

```powershell
cargo build --manifest-path native/Cargo.toml -p arkhe-crm-bridge-cli --locked
# Assinar no processo do produtor, com a versão efetivamente observada:
native/target/debug/arkhe-crm-bridge-cli sign-write --proof private/proof.json --policy private/policy.json --expected-version 2026-10-25T12:00:00.123Z --secret private/producer.key
# Salvar stdout como private/intent.json, preservando UTF-8.
python scripts/deliver_write.py --org validate-sandbox --intent private/intent.json --policy private/policy.json --bridge-bin native/target/debug/arkhe-crm-bridge-cli --journal private/delivery.sqlite
# Recuperação após timeout ou reinício, sem mutação:
python scripts/deliver_write.py --org validate-sandbox --intent private/intent.json --policy private/policy.json --bridge-bin native/target/debug/arkhe-crm-bridge-cli --journal private/delivery.sqlite --reconcile-only
```

No Windows, o executável pode exigir o sufixo `.exe`. A política e o binário
devem vir de origem confiável. O processo emissor precisa de OAuth/API, acesso
ao Lead/campos e `Arkhe_Bridge_Issuer`. Esse permission set não concede acesso
ao Lead automaticamente. Comparação de versão nunca é refeita com uma versão
mais nova para contornar conflito: exige nova decisão assinada do produtor.

O entregador verifica bundle, assinatura da intenção, escopo/org e validade;
grava intenção pendente em SQLite antes da primeira mutação; procura aprovação
por event_id e compara seu conteúdo imutável antes de tentar criar. A escrita
é PATCH do campo aprovado; o trigger decide e consome na mesma transação.
Depois lê aprovação e Lead. Uma resposta perdida é reconciliada sem reemitir
uma aprovação já consumida. Um valor posteriormente alterado não é reaplicado.
No-op não é contado como consumo. Os únicos escopos são LeadSource e os quatro
campos de laboratório, com texto de até 255 caracteres ou null.

O diário contém valores de negócio: proteger diretório/ACL, backup e retenção.
Não publicar bundle, diário, keyfiles ou logs de dados em Git/artefatos públicos.
Perder o diário exige reconciliação operacional usando a prova e a aprovação;
não recriar automaticamente aprovações expiradas. `--reconcile-only` requer o
diário original e permanece somente leitura remota.

## Outbox, OAuth de saída e ordem de execução

O Flow ativo `Arkhe_Consumed_Approval_Outbox` cria uma `Arkhe_Delivery__c` quando
Consumed_At passa de null para preenchido. A aprovação é consumida pelo gate
no after update do Lead; o Flow roda dentro da atualização da aprovação. Nada
é enviado antes do commit. Se uma falha posterior rejeita a escrita, aprovação
e outbox precisam reverter juntas. O teste de sucesso parcial passou a exigir
outbox somente para o Lead salvo; essa asserção ainda depende de execução na org.

`ArkheDeliverySchedule` inicia Batch com scope 50; cada lote enfileira um
Queueable com AllowsCallouts. A consulta seleciona Pending/Retry vencidos;
o Queueable faz um único POST e só depois atualiza o estado. Cinco tentativas
levam a Dead; retries esperam 1, 4, 9 e 16 minutos. Jobs podem ser duplicados:
o receptor DEVE deduplicar por event_id e comparar request_hash/checkpoint_hash.
Não se promete entrega exatamente uma vez. Falha após aceite remoto e antes
do DML local exige retry idempotente.

Contrato: POST `/v1/receipts`, JSON `{schema:1,events:[{event_id,request_hash,
checkpoint_hash,consumed_at}]}`. HTTP 204 significa aceite durável de TODOS os
eventos. Qualquer outro status ou timeout mantém retry/Dead. O receptor não
recebe valores de Lead nem tokens no payload. O serviço receptor OAuth e sua
operação não são provisionados aqui; mocks não validam autenticação real.

Configurar External Credential OAuth 2.0 com principal dedicado e grant
adequado ao provedor (preferencialmente client credentials quando suportado),
scope restrito a receipts, segredo no armazenamento de credenciais Salesforce
e acesso ao principal apenas para o usuário que agenda o Batch. Gerar a Named
Credential moderna que referencia esse External Credential já configurado:

```powershell
python scripts/configure_receipt.py --endpoint https://SEU_HOST --external-credential Arkhe_Receipt_OAuth
sf project deploy start --source-dir environment-config --target-org validate-sandbox
```

Autenticar o principal e ensaiar 204, 401/403, timeout, rotação, revogação e
reentrega. Só então agendar explicitamente `ArkheDeliverySchedule` com nome
único e cron aprovado. Nenhum schedule é criado pelo deploy. Future não foi
adicionado: este caso requer jobs rastreáveis, Queueable e recuperação durável.

## Aceite na org e recuperação

1. Executar check-only QA e guardar JSON, JUnit e cobertura. Confirmar todos os
   asserts, incluindo sucesso parcial/Flow e mocks de callout.
2. Criar trace flags limitadas para o usuário de teste. Guardar logs completos
   com ARKHE_METRICS e ARKHE_GATE_TRACE em armazenamento restrito. Verificar CPU,
   heap e consultas do lote 200×5 com automações reais; cobertura não é headroom.
3. Com candidato implantado somente em QA, executar race-sandbox.py e
   security-probe.py com dois usuários reais e fixtures sintéticas. IDs devem
   ser da mesma org. Correlacionar request_id com logs e demonstrar os intervalos
   de servidor: a barreira dos clientes sozinha não comprova contenção.
4. Ensaiar escrita pelo entregador, perda de resposta após POST/PATCH, rollback
   por Flow/trigger posterior e reconciliação após restart. Validar precisão de
   SystemModstamp e null no roundtrip REST. Remover ou mascarar dados sensíveis.
5. Ensaiar receptor OAuth e drain da outbox, fila Dead e alertas. Definir RPO/RTO,
   retenção e custódia de chaves antes de aceitar produção.

Antes de promover, o script recupera metadados Arkhe existentes em
`evidence/predeploy`. Falha no backup interrompe a promoção. Para primeira
instalação sem nenhum componente existente, um erro NothingRetrieved deve ser
resolvido documentando a baseline vazia e preparando um backup de baseline
apropriado; não ignorar cegamente erros de retrieve.

Rollback: suspender primeiro emissor e agenda de entrega; registrar SHA e job
ID; consultar `sf project deploy report` se o deploy foi interrompido. Restaurar
em QA o backup predeploy ou commit anterior, validar e promover pela mesma
proteção. Uma instalação inicial pode exigir desativar o Flow adicional; não
apagar objetos, aprovações, eventos ou diário para simular rollback. Aprovações
consumidas e recibos externos permanecem histórico: correção de valor requer
um novo evento assinado, não desfazer o consumo. Recuperar bancos a partir de
backup exige reconciliar o CRM e a testemunha externa antes de retomar emissão.
Este procedimento está documentado, mas ainda não foi ensaiado em org.

## Referências oficiais

- CLI sandbox versus produção: https://developer.salesforce.com/docs/platform/salesforce-cli-reference/guide/cli_reference_project_deploy_validate.html
- Named Credentials: https://developer.salesforce.com/docs/platform/named-credentials/guide/get-started.html
- Segredos de External Credentials: https://developer.salesforce.com/docs/platform/named-credentials/guide/nc-populate-external-credentials.html
- Queueable e callouts de triggers: https://trailhead.salesforce.com/content/learn/modules/apex_triggers/apex_triggers_intro
