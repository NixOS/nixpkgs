# Gate Salesforce — desenho e candidato para sandbox, sem implantação

Status: desenho revisado contra documentação oficial. Há um candidato Apex e
testes preparados em [salesforce/](../salesforce/README.md), com sintaxe conferida
localmente; sem compilação, deploy ou validação em sandbox. O CLI v2 implementa
proveniência; não bloqueia escritas em uma organização Salesforce.

## Restrição confirmada

Callouts originados em triggers devem usar execução assíncrona, por exemplo
Queueable com `Database.AllowsCallouts`. Não se pode aguardar um callout do
Bridge dentro do before trigger para decidir a mesma escrita. Fontes:
[Salesforce: fundamentos de triggers](https://trailhead.salesforce.com/content/learn/modules/apex_triggers/apex_triggers_intro)
e [Salesforce: REST callouts](https://trailhead.salesforce.com/content/learn/modules/apex_integration_services/apex_integration_rest_callouts).

Logo, ancoragem assíncrona posterior ao commit só oferece evidência posterior.
Bloqueio exige uma aprovação pronta antes da tentativa de alteração protegida.

## Fluxo proposto para updates de registros existentes

1. Produtor assina evento com identidade exata da org, registro, campo e valor.
   Bridge valida o v2 e grava checkpoint e resposta transacionalmente.
2. Serviço integrador verifica o bundle e obtém uma aprovação de escrita com
   validade curta. A aprovação vincula event_id, checkpoint, identidade do alvo,
   novo valor, versão esperada do registro e prazo de uso. Esta aprovação é um
   contrato adicional; não é o bundle histórico v2.
3. Principal de integração autorizado grava `Arkhe_Write_Approval__c` no CRM.
   Usuários comuns não podem criar, editar ou excluir aprovações. event_id é
   único também no CRM. Compartilhamento, CRUD/FLS e permissões precisam ser
   definidos e testados; o cadastro da aprovação é parte da fronteira confiável.
4. Escrita do campo chega ao trigger. Handler bulk consulta e bloqueia as
   aprovações aplicáveis com `FOR UPDATE`. Confere org, alvo, campo, valor exato,
   prazo, estado não consumido e versão esperada antes de aceitar a alteração.
5. Ausência, divergência, expiração, aprovação consumida ou falha de consulta
   gera `addError`. Consumo da aprovação e alteração devem ocorrer na mesma
   transação Salesforce: rollback de uma desfaz a outra.
6. Confirmação ao Bridge e reconciliação ocorrem depois do commit, com retry.
   Não há transação distribuída entre SQLite e Salesforce: checkpoints podem
   existir para escritas recusadas; ancorado não significa aplicado no CRM.

O gate local confia no principal que cadastra aprovações após verificar a
criptografia. Ele não deve aceitar um JSON arbitrário ou um booleano "verified"
escrito por usuários. Uma alternativa com verificação criptográfica em Apex
exige prova de compatibilidade, limites e gestão de chaves separada.

O v2 não vincula versão anterior do registro nem implementa a aprovação de
escrita. A versão esperada deve ser capturada antes da aprovação e vinculada
ao novo contrato para impedir sobrescrita por uma proposta obsoleta. Inserções
de Lead sem ID Salesforce ficam fora deste primeiro gate: exigem identidade
externa estável e protocolo explícito de associação ao ID criado.

## Plano de validação obrigatório em sandbox

| Cenário | Resultado esperado |
| --- | --- |
| Update autorizado e aprovação válida | Campo e consumo persistem juntos |
| UI, REST, Flow e import sem aprovação | Escrita protegida rejeitada |
| Alteração de campo fora do escopo protegido | Política específica, sem bloqueio acidental |
| Valor, alvo, org ou campo divergente | Rejeição |
| Aprovação expirada/consumida | Rejeição |
| Duas transações usam a mesma aprovação | No máximo uma aceita |
| Registro mudou após emitir aprovação | Rejeição por versão obsoleta |
| Lote de 200 registros e múltiplos campos | Consultas/DML bulk; medir CPU e heap |
| Falha após consumir e antes de concluir DML | Rollback restaura aprovação e campo |
| `allOrNone=false` e retries parciais | Consumo acompanha somente registros efetivamente aceitos |
| Trigger recursivo e automações na mesma transação | Sem reaproveitar aprovação ou ignorar novo valor |
| Usuário tenta forjar/alterar aprovação | CRUD/FLS/compartilhamento impedem |
| Bridge indisponível | Novas escritas sem aprovação rejeitadas; recuperação idempotente |
| Aprovação gravada, escrita falha, serviço reinicia | Retry/reconciliação sem duplicar aplicação |
| Lote 200 × 5 com CPU, heap e consultas registrados | Medir headroom e guardar logs reais |
| REST por usuário sem CRUD/FLS nem custom permission | Acesso negado observado, com código real |
| CRUD concedido por engano sem custom permission | Guard ainda rejeita emissão |
| Linha muda enquanto FOR UPDATE aguarda | Revalidar predicados após lock |
| DML parcial falha depois do consumo | Aprovação da linha rejeitada permanece disponível |
| Duas requisições gravam o mesmo valor | Distinguir no-op de reutilização da aprovação |

`addError` não implica rollback global quando o cliente permite sucesso parcial.
Triggers podem ser repetidos na mesma transação sem reset das variáveis estáticas.
O candidato evita um marcador estático de "já processado" e prepara um teste com
falha posterior ao consumo. Resultado só será confirmado após execução na org.

`FOR UPDATE` pode esperar por lock e falhar por contenção; não garante que o
registro ainda corresponda aos filtros originais. O candidato revalida todos
os predicados de autorização após o lock. Concorrência não deve exigir uma
mensagem específica de erro: timeout de lock também pode rejeitar a tentativa.

Fontes oficiais adicionais: [revalidação de filtros após espera por lock](https://help.salesforce.com/s/articleView?id=000387467&language=en_US&type=1),
[sucesso parcial e addError](https://trailhead.salesforce.com/content/learn/modules/apex_triggers/apex_triggers_intro),
[retries e persistência de static em DML parcial](https://help.salesforce.com/s/articleView?id=005386519&language=sv&type=1).

Nenhum desses cenários Apex foi executado nesta entrega. A evidência local
cobre o protocolo e armazenamento Rust, não essas garantias da plataforma.
