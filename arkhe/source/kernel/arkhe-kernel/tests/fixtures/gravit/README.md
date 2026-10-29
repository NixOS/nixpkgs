# Fixture negativa Gravit v0.6.0

Origem: `docs/evidence/2026-10-24-gravit-review/contract-probes.json`, sondagem `nonempty_nonhash_is_not_recomputed`, executada com verifier commit `7887252fc84def69a794d2e32ce65721eb9a25d9` e chaves públicas de teste.

`invalid-hash-request.json` e `invalid-hash-decision.json` preservam os valores dessa sondagem, serializados em JSON compacto UTF-8 sem BOM. Não são os bytes brutos do transporte upstream. O teste compromete os bytes desta fixture sem normalizar os floats. A resposta é SUCCESS / Verified Fact, mas o hash não representa o conteúdo local.

O controle positivo do teste modifica o hash: suas assinaturas originais deixam de ser válidas. Ele cobre somente vínculo de digest e governança de teste; não é fixture criptográfica positiva.

O subdiretório `signatures/` contém um controle positivo separado, com hashes corretos e assinaturas refeitas usando sementes públicas de teste; também contém casos de chave revogada/desconhecida e uma decisão adulterada com ID recalculado. Gerador: `scripts/gravit_signature_fixtures.py`. O par de referência é um oráculo fixo de replay, não uma decisão assinada. `manifest.json` registra hashes e o commit do verificador Python utilizado.
