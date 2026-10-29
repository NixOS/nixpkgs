# Protocolo CRM Bridge v2

Status: implementado e testado localmente; sem auditoria criptográfica externa.
O formato v2 é incompatível com a prova v1. A API v1 na raiz da biblioteca é
mantida como referência do protótipo; o CLI opera exclusivamente em v2.

## Bytes canônicos

JSON é somente transporte. Os bytes assinados não dependem de whitespace,
ordem das propriedades ou escapes JSON equivalentes. Campos desconhecidos,
duplicados e versões desconhecidas são rejeitados pelo desserializador.

Defina `F(x) = u64be(tamanho_em_bytes(x)) || x`. Todas as entradas abaixo são
enquadradas individualmente por F. Strings são UTF-8 exato, sem normalização
Unicode. Inteiros de protocolo são oito bytes unsigned big-endian, também
enquadrados por F. Não há BOM, separadores ou terminador nos bytes canônicos.

Evento, em ordem:

1. String de domínio `arkhe.crm.event.v2`.
2. Inteiro 2; strings log_id, event_id, producer_id.
3. Inteiros issued_at e expires_at, Unix UTC em segundos.
4. Strings org_id, object, record_id e field.
5. Valor tipado: string `null` sem payload; `bool` seguida de F(um byte 0 ou 1);
   `string` seguida de F(UTF-8); ou `integer` seguida de F(decimal ASCII mínimo,
   sinal negativo somente quando necessário). Inteiros de valor abrangem i64
   e u64; clientes JavaScript devem preservar inteiros grandes com precisão.
6. Strings source_system e observed_at.

Arrays, objetos e floats são rejeitados. `observed_at` exige a representação
UTC RFC3339 com segundos inteiros e Z, por exemplo `2026-10-22T12:00:00Z`.
Identificadores não vazios têm limite de 1024 bytes; strings de valor, 65536.
O instante observado é declaração assinada do produtor; não é uma fonte de
tempo confiável, nem é obrigado a coincidir com a emissão do envelope.

`record_hash = hex_lower(BLAKE3(bytes_canônicos_do_evento))`. O nome histórico
inclui aqui o envelope completo, com identidade, log, ID e validade do evento.
A assinatura do produtor é Ed25519 diretamente sobre esses bytes, não sobre
o JSON ou a representação hexadecimal do hash. Chaves são hex lowercase de
32 bytes; assinaturas, 64 bytes. A verificação usa `verify_strict`.

Checkpoint, em ordem:

1. String `arkhe.crm.checkpoint.v2`; inteiro 2; string log_id.
2. F(32 bytes da raiz MMR); inteiro leaf_count.
3. F(32 bytes do hash do checkpoint anterior), zeros para o primeiro.
4. Inteiro issued_at; F(32 bytes do hash da política).

A assinatura do Bridge cobre todos esses bytes. O hash do checkpoint é BLAKE3
desses bytes, sem a assinatura. A folha MMR é o hash binário do evento; a
construção de nós, picos e bagging reutiliza `arkhe-verify-core`.

Política, em ordem:

1. String `arkhe.crm.policy.v2`; inteiro 2; strings log_id e bridge_public_key.
2. Inteiros max_age_secs, max_ttl_secs e future_skew_secs.
3. Quantidade de produtores, ordenados lexicograficamente pelo id UTF-8.
4. Para cada produtor: strings id, public_key, org_id, source_system e object;
   quantidade de fields distintos e cada field, em ordem lexicográfica UTF-8.

O hash da política é BLAKE3 desses bytes. IDs de produtores duplicados são
rejeitados. Uma concessão autoriza uma organização, origem, objeto e lista
exata de campos. Para múltiplos escopos, use identidades distintas. A política
é distribuída por canal confiável; não é aceita a partir do próprio bundle.

## Persistência e replay

Um arquivo SQLite representa um log e uma política fixos. A primeira inserção
fixa o hash da política. Não há rotação implícita de chaves nem edição de
permissões em um log existente: uma migração exige um procedimento futuro,
com histórico de políticas e evidência da transição.

`BEGIN IMMEDIATE`, WAL e `synchronous=FULL` serializam escritores e gravam
evento, chave única event_id e resposta completa na mesma transação. O commit
precede stdout; `export` recupera a resposta após interrupção de entrega.
Transações que falham não consomem event_id. A durabilidade pressupõe disco e
sistema de arquivos que cumpram as garantias do SQLite.

Antes de admitir um evento novo, o Bridge valida assinatura e escopo, TTL,
idade máxima e desvio futuro. Relógio do Bridge é confiável por hipótese;
emissões de checkpoint não podem retroceder no mesmo diário. Cada checkpoint
é encadeado ao anterior. Antes de estender o log, todo o histórico armazenado
é revalidado e as raízes são reconstruídas.

Repetição exata de event_id e requisição devolve o bundle original, inclusive
após expiração, sem criar folha nova. Mesmo event_id com conteúdo diferente
é conflito. A unicidade abrange todo o log, não somente o produtor. Um produtor
autorizado ainda pode emitir o mesmo valor com outro event_id: deduplicação
semântica e aplicação única no CRM precisam de política de negócio própria.

## Garantias e limites

O auditor valida assinatura do produtor, escopo e validade na data do
checkpoint, assinatura do Bridge, hash do evento e inclusão MMR. O tamanho
é uma afirmação assinada do Bridge; a prova MMR não comprova sozinha a
completude do diário nem a posição da folha. Verificação histórica continua
válida depois que o evento expira; não deve autorizar uma nova escrita no CRM.

Um bundle isolado não prova que o checkpoint seja o mais recente nem que não
existam forks. Retenha checkpoints externamente para comparar progresso e
cadeia. Rollback completo do banco restaura também as chaves de replay; defesa
contra um administrador malicioso requer testemunha externa/ancoragem e
recuperação que consulte essa testemunha. Não existe isso nesta versão.

Chaves privadas do produtor e do Bridge pertencem a processos distintos.
O CLI usa arquivos locais; produção precisa de gestão de segredos e operação
de rotação/revogação. No Windows as ACLs são herdadas do diretório: use um
diretório restrito. Valores e bundles não são cifrados.

O algoritmo de armazenamento reconstrói cada prefixo para conferir o histórico;
o custo de uma nova inserção é quadrático no número de eventos. É uma base de
correção para testes e pilotos pequenos; ainda não é adequado a grandes lotes.

## Vetor congelado

`fixtures/event-v2.json` e `fixtures/golden-v2.json` fixam bytes, hash e assinatura.
A seed pública `[2; 32]` usada no vetor é exclusivamente de teste. O exemplo
`golden_v2` auxilia a inspeção; mudanças no vetor exigem revisão do contrato,
não regeneração automática para fazer um teste passar.
