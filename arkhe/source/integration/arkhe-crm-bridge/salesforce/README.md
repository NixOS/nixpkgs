# Gate Salesforce — candidato exclusivo para sandbox

Implementação Apex preparada, com sintaxe validada localmente. **Não compilada
pela Salesforce, não implantada e sem testes executados em org.** Não é uma
garantia de bloqueio validada. O protocolo Rust v2 permanece independente.

Atualização de 25/10: [operação, CI e recuperação](docs/OPERATIONS.md) inclui
intenção de escrita assinada pelo produtor vinculando SystemModstamp, entregador
REST com diário SQLite, Flow de outbox e Queueable/Batch/Schedulable com mocks.
As novas classes e Flow também continuam sem compilação/execução em org.

## Escopo concreto

Somente updates de Leads existentes. Campos protegidos: LeadSource e quatro
campos de texto de laboratório `Arkhe_Test_1__c` a `Arkhe_Test_4__c`. Inserções,
outros objetos e campos não estão cobertos. Os quatro campos existem para o
ensaio 200 × 5, não representam um mapeamento de produção. `sign-write` adiciona
a versão assinada ao bundle; `deliver_write.py` verifica pelo binário Rust antes
de emitir aprovação. O fluxo é implementado localmente e ainda não executado na org.

`Arkhe_Write_Approval__c` contém event_id único e sensível a caixa, alvo, org,
campo, valor ou null explícito, SystemModstamp esperado, expiração de até cinco
minutos, produtor e hashes da requisição/checkpoint. Somente um emissor com a
custom permission `Arkhe_Issue_Approval` pode inserir. Alteração de conteúdo
e exclusão são bloqueadas por trigger mesmo em Apex system mode. O permission
set do emissor concede criação/leitura, sem edição/exclusão; campos obrigatórios
não recebem entradas FLS que a Metadata API não admite.

O gate usa system mode intencionalmente para consultar aprovações privadas e
consumir somente as que correspondem à escrita. Não há endpoint público Apex.
CRUD/FLS do cliente continua responsabilidade do ponto de entrada Salesforce.
A custom permission é uma segunda barreira contra concessão acidental de CRUD;
não protege contra um administrador que conceda a própria custom permission ou
desative os triggers. Administradores e código Apex implantado são confiáveis.

## Consumo e sucesso parcial

Before update confere aprovações bloqueadas com `FOR UPDATE`. After update
repete a conferência e consome somente as aprovações de registros que passaram
no handler. Valores de texto usam `.equals`, pois `==` em strings Apex ignora
caixa. Expiração, consumo e demais predicados são revalidados depois do lock.
Falha de consulta ou ambiguidade de aprovações rejeita a escrita.

Não há static flag de "já processado": Salesforce pode repetir triggers no
mesmo contexto após rollback parcial. A única capacidade estática de consumo
existe ao redor do DML das aprovações e é limpa em `finally`. O teste de
`Database.update(..., false)` injeta erro depois do consumo e exige que somente
o registro efetivamente salvo tenha aprovação consumida. **Esse teste ainda
precisa passar na plataforma.** `addError` não significa rollback irrestrito de
todas as linhas em sucesso parcial.

A expiração é avaliada na validação/consumo, não como garantia de relógio no
instante físico do commit. Uma segunda requisição que deixe o valor inalterado
não exige aprovação; pode retornar 204 como no-op. Portanto "duas respostas de
sucesso" não equivale a "duas utilizações da aprovação".

## Verificação local reproduzível

```powershell
cd D:/arkhe/integration/arkhe-crm-bridge/salesforce
npm ci --ignore-scripts
npm run check:syntax
```

O parser verifica gramática de classes, triggers e SOQL, mas não substitui
compilador, validação Metadata API, CRUD/FLS, cobertura ou execução Salesforce.
Os XMLs foram gerados por `../scripts/generate-salesforce-metadata.py` e
conferidos localmente. Não instale o pacote em produção.

## Validação na sandbox

Pré-requisitos: Salesforce CLI `sf`, org sandbox autenticada, licença Salesforce
e perfil padrão sem ModifyAllData disponível para os dois usuários de teste.
Use inicialmente uma sandbox limpa; automações, regras e picklists da org podem
alterar resultados. Nenhuma org foi selecionada automaticamente.

```powershell
python scripts/validate-sandbox.py --org SEU_ALIAS_SANDBOX
```

O script consulta `Organization.IsSandbox` antes de executar `sf project deploy
start --dry-run`. Compila e roda `ArkheWriteGateTest` sem persistir o deploy,
salvando o JSON em `evidence/validation.json`. Um timeout ou job pendente não
confirma aprovação; consulte o job até terminar. As seis rotinas Apex preparadas
cobrem sucesso/replay, imutabilidade, emissor não autorizado em system/user mode,
rollback parcial posterior, ausência/divergência/versão obsoleta, recuperação,
expiração na emissão, event_id duplicado e lote 200 × 5.

Além das seis rotinas do gate há seis testes de entrega/Flow/assíncrono e mocks
em `ArkheDeliveryTest`. O check-only executa RunLocalTests por padrão; o modo
RunSpecifiedTests inclui as duas classes. Cobertura ausente, inferior a 75% por
componente ou job pendente falha no avaliador local de resultados.

O teste bulk registra `ARKHE_METRICS` com CPU, heap e consultas e exige menos
de 10.000 ms, menos de 6.000.000 bytes e no máximo duas consultas do gate em
org limpa. Preserve o debug log para inspecionar os números; o resultado JUnit
sozinho não documenta custo operacional. Valide ainda headroom com automações
reais, concorrência e múltiplos lotes. Não mova a decisão de bloqueio para
Queueable para resolver estouro de CPU: isso mudaria a garantia síncrona.

Os 6.000.000 bytes são orçamento conservador do projeto, não uma afirmação do
limite atual da plataforma. O log também registra `Limits.getLimitHeapSize()` e
`Limits.getLimitCpuTime()`. O heap medido é uma amostra ao final do update, não
o pico da transação. [Winter ’27 aumenta o heap para 10 MB síncronos e 25 MB
assíncronos](https://developer.salesforce.com/blogs/2026/10/developers-guide-to-the-winter-27-release);
uma configuração da sandbox pode manter o limite anterior. Use os limites
efetivos registrados, não apenas a versão de API do pacote, ao interpretar logs.

Separe as janelas de validação/testes e de ensaio concorrente. A [Salesforce
documenta compile locks](https://help.salesforce.com/s/articleView?id=000384898&language=ja&type=1)
para `SoapOperationRunTests` e testes com cobertura; não trate toda execução via
API como equivalente. Conclua a validação com cobertura antes do ensaio HTTP.
Se houver execução adicional pela UI, Setup → Apex Test Execution sem cobertura
é a alternativa assíncrona descrita no artigo. Nenhuma suite deve ser executada
ao mesmo tempo que o ensaio de contenção do gate.

Para Metadata API, [Modify Metadata Through Metadata API Functions ou Modify
All Data](https://help.salesforce.com/s/articleView?id=meta_modify_metadata_perm.htm&language=en_US&type=5)
é parte dos requisitos, junto das permissões específicas de Apex e da ferramenta.
Não conceda Modify All Data como requisito universal. Deployment connection
autoriza [change sets entre orgs](https://help.salesforce.com/s/articleView?id=sf.changesets_admin_connection_details.htm&language=en_US&type=5);
não é pré-requisito para o check-only direto na sandbox autenticada.

O trigger é alcançado pelo PATCH REST padrão de Lead; não precisa de endpoint
Apex REST próprio. O probe com dois clientes testa consistência, não tenta
descobrir o ponto de saturação da org. Limites de requisições Apex longas e
[limites de concorrência das APIs](https://developer.salesforce.com/docs/platform/salesforce-app-limits-cheatsheet/guide/salesforce-app-limits-platform-api.html)
são categorias distintas; não use os números de uma como garantia para a outra.

### Consultas bulk e evidência de contenção

O handler tem uma única consulta SOQL bulk, fora dos loops, usando o conjunto
de Leads como filtro. Ela é executada em before update e after update: duas
consultas por ciclo normal, não uma por campo ou aprovação. No cenário 200 × 5,
1000 aprovações podem ser lidas em cada fase. O LIMIT 2001 permite detectar
mais de 2000 candidatas e rejeitar o lote. Isso não elimina custo de heap/CPU,
consumo de linhas por outras automações ou novas invocações em retries.

`ARKHE_GATE_TRACE` registra `lock_attempt`, `lock_query_returned`,
`lock_query_failed`, `consume_attempt` e `consume_dml_returned`, com timestamp
do servidor, fase before/after, IDs dos Leads/aprovações e
[`Request.getCurrent().getRequestId()`](https://developer.salesforce.com/blogs/2026/03/set-up-cross-system-observability-with-correlation-ids).
Não há valores de campos no payload. Os logs exigem trace flag e nível INFO
ou superior apropriado; eles podem registrar tentativas posteriormente revertidas.
`consume_dml_returned` não é um evento de commit. Retries parciais podem gerar
múltiplos eventos com o mesmo request_id; preserve a sequência inteira do log.

O probe HTTP salva ID local da tentativa, início/fim e duração no cliente e
headers de request ID quando retornados. Header ausente permanece ausente;
não presumimos que um header seja automaticamente igual ao request_id Apex.
Os campos `server_overlap_proven` e `response_to_apex_log_correlation_verified`
permanecem falsos: o script não analisa logs de servidor para estabelecê-los.

Critério para o ensaio seguinte: correlacionar os dois requests com logs reais,
demonstrar sobreposição de intervalos do servidor e examinar os mesmos alvos,
aprovações, espera/erro de lock e resultado persistido. Uma consulta lenta ou
um erro genérico não demonstram, isoladamente, espera por aquela aprovação.
Locks implícitos do próprio Lead também podem serializar a operação; observar
dois PATCHs não garante disputa dentro do FOR UPDATE das aprovações. Se a
serialização impedir a sobreposição nesse ponto, o resultado é inconclusivo
para contenção no objeto de aprovação, não uma falha automática do gate.

Não se usa contador `Lock_Attempt__c`: incrementá-lo exigiria DML e introduziria
outro ponto de contenção; ele ainda poderia desaparecer com rollback. Não se
usa `Thread.sleep`, nem loop de espera que consuma CPU, nem callout para simular
espera: este último [libera locks FOR UPDATE](https://help.salesforce.com/s/articleView?id=release-notes.rn_apex_debuglog.htm&language=en_US&release=248&type=5).
Qualquer harness de contenção artificial deve ser separado do gate e revisado
como experimento de sandbox antes de ser executado.

A expiração é revalidada também imediatamente antes do DML de consumo. Se uma
aprovação selecionada já expirou, todas as alterações protegidas daquela
invocação são rejeitadas conservadoramente, sem consumo. Isso reduz a janela
entre validação e uso, mas não cria uma garantia sobre o instante físico do
commit nem altera a política de prazo da aprovação.

Teste offline do transporte: `python scripts/test_sandbox_transport.py`. Ele
verifica captura em sucesso/erro, ausência de IDs e exclusão de headers de
cookie e credenciais da evidência. Não realiza chamadas à Salesforce.

Após revisar resultados e implantar explicitamente o candidato na sandbox,
atribua `Arkhe_Bridge_Issuer` somente ao usuário integrador de teste, com acesso
REST e ao Lead. Para a prova com dois clientes reais:

```powershell
python scripts/race-sandbox.py --org ALIAS_EMISSOR_SANDBOX
```

O script cria fixtures sintéticas, dispara dois PATCHs concorrentes e salva
respostas e estado final. As fixtures ficam na org para inspeção; aprovações
são imutáveis inclusive para exclusão. Ele usa hashes sintéticos, não evidência
criptográfica real. Não prova sobreposição de execução no servidor nem conta
transições internas do consumo: correlacione logs de servidor e repita a matriz.
Dois Queueables também não garantem execução simultânea; `Test.stopTest()` não
é um ensaio de contenção real.

Com outro usuário da mesma sandbox, sem a custom permission nem CRUD de aprovação:

```powershell
python scripts/security-probe.py --issuer-org ALIAS_EMISSOR_SANDBOX --unprivileged-org ALIAS_USUARIO_SANDBOX --lead-id ID_FIXTURE --approval-id ID_APROVACAO_FIXTURE
```

O probe tenta criar/editar/excluir via REST. Só marca acesso negado quando há
código de autorização reconhecido; erro de validação não conta como aprovação
do teste CRUD/FLS. Use exclusivamente fixtures de sandbox. Tokens de sessão são
lidos do CLI em memória e não são gravados nos arquivos de evidência.

## Postura do principal de integração

O emissor verifica assinatura, política, escopo e validade antes de cadastrar
aprovação e vincula a versão atual do registro ao novo contrato. O gate não
reexecuta essa criptografia. Os hashes armazenados são referências fornecidas
pelo emissor; por si sós não comprovam verificação. Comprometer a identidade
emissora permite forjar aprovações dentro do escopo implementado.

Requisitos de implantação: usuário dedicado, OAuth com escopo mínimo e política
de sessão restrita; segredos em cofre; acesso administrativo protegido por MFA;
inventário, rotação e revogação testados; auditoria de login e emissão;
alerta para alteração de permissões/triggers; reconciliação entre aprovação,
checkpoint e escrita efetiva. MFA interativo não substitui proteção de tokens
de integração. Nenhum desses controles foi provisionado automaticamente.

## Critérios ainda sem evidência de execução

- Compilação, cobertura e todos os asserts Apex na org.
- CPU/heap sob carga real e efeito do limite de 2000 aprovações candidatas.
- Concorrência com logs correlacionados, timeout de lock e retry.
- Expiração entre emissão e uso, null, aprovações ambíguas e múltiplas automações.
- Comportamento de SystemModstamp e precisão DateTime no roundtrip REST.
- Rollback parcial com regras e triggers reais posteriores ao gate.
- REST CRUD/FLS com usuários reais e tentativa de concessão acidental de CRUD.
- Ordem de execução, recursão, conversão e alterações por workflows/Flows.
- Recuperação após emissão persistida sem escrita e reconciliação com o Bridge.

Fontes oficiais: [triggers e sucesso parcial](https://trailhead.salesforce.com/content/learn/modules/apex_triggers/apex_triggers_intro),
[CRUD/FLS e system mode](https://developer.salesforce.com/docs/platform/secure-coding/guide/secure-coding-access-control-protect-from-crud-fls-vulnerabilities.html),
[revalidação após FOR UPDATE](https://help.salesforce.com/s/articleView?id=000387467&language=en_US&type=1).
