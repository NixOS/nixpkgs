# ADR 0002 — Builds endereçados por conteúdo

## Contexto

O requisito declarado é "builds 100% reprodutíveis, endereçados por conteúdo".
No Nix, um caminho de store é, por padrão, **endereçado por entrada**
(input-addressed): deriva do hash do derivado, não do conteúdo produzido. Duas
construções com o mesmo derivado compartilham o path mesmo que o conteúdo
divirja — o que esconde não-determinismo.

## Decisão

- Todo pacote aceita `contentAddressed ? false`.
- Quando verdadeiro, o derivado recebe `__contentAddressed = true;` e
  `outputHashMode = "recursive";`.
- As variantes CA são expostas em `legacyPackages.<system>.ca`, não em
  `packages`, para que `nix flake check` continue funcionando sem a feature
  experimental.
- O overlay aceita `contentAddressed = true` para uso em NixOS.

## Alternativas descartadas

| Alternativa | Por que não |
|---|---|
| Tornar CA o modo padrão | `ca-derivations` é experimental e exige configuração explícita; quebraria `nix flake check` em instalações padrão. |
| `nix store make-content-addressed` como única estratégia | Reescreve o fecho depois do build; não detecta não-determinismo na produção. Continua útil como verificação complementar. |
| Ignorar CA e chamar o build de "content-addressed" | Seria falso: input-addressed não é content-addressed. |

## Consequências

- Usar CA exige `experimental-features = nix-command flakes ca-derivations`.
- Com CA, o path muda quando o conteúdo muda: divergência vira erro visível.
- CA **não** torna o build determinístico; ele apenas torna o endereço
  dependente do conteúdo. Determinismo vem dos mecanismos descritos em
  `docs/reproducibility.md`.
- A verificação automatizada está em `scripts/verify-content-addressing.sh` e
  no job `ca` do CI.
