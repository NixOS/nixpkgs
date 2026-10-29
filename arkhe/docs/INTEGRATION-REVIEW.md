# Revisão e integração — 2026-10-29

A integração reside em `arkhe/`, preservando o flake e os pacotes Nixpkgs na raiz.
Use `nix build ./arkhe#arkhe-verify` ou o flake remoto com `?dir=arkhe`.

## Correções

- Fonte local implícita substituída por snapshot em `source/`, com manifesto SHA-256 por arquivo. O workspace público rafael-arkhe/arkhe tem outra estrutura e não é uma fonte válida para estes pacotes.
- CI próprio na raiz, disparado em master/main e PRs; execução em arkhe/.
- Verificador padrão; WASM disponível apenas pela API parametrizada/legacyPackages com toolchain adequada, fora de packages.
- Testes do verificador incluem arkhe-verify-core e arkhe-core; testar apenas o CLI não cobria os vetores.
- Perfil audit instala somente o verificador escolhido, sem arrastar runtime e integrações.
- Arquivo de ambiente tratado como caminho de execução (string), sem copiar segredos para o store.
- Scripts aceitam os formatos array e objeto de `nix path-info --json`.

## Limites

O snapshot é uma cópia de fontes locais, não um release upstream assinado. Confira `source-manifest.json` antes de publicar. Não há alegação de reprodutibilidade bit-a-bit nem de CA validada até executar os checks. O template by-name contém fakeHash e não está pronto para submissão upstream. WASM requer toolchain com std do alvo. Não foram implementadas cadeia de boot, IMA, TPM ou assinatura híbrida do sistema operacional.

Os bytes originais do snapshot (inclusive CRLF) são preservados para conferir o manifesto. Arquivos de empacotamento Nix, scripts e CI usam LF. O teste de módulos usa pacotes substitutos para conferir caminhos de segredos e instalação sem exigir overlay.

## Validação executada

Nix 2.35.4 no Ubuntu/WSL: avaliação para x86_64-linux e aarch64-linux aprovada; build e 81 testes de arkhe-verify aprovados; smoke e módulos aprovados; reconstrução na mesma máquina com hash idêntico e build CA aprovados. Resultados e logs em `validation/`. Builds dos demais pacotes, WASM e repetição em máquina independente permanecem pendentes.
