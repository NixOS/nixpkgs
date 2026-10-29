# Revisão e integração — 2026-10-29

A camada Arkhe reside em `arkhe/`, preservando o flake e os pacotes Nixpkgs na raiz. Use `nix build ./arkhe#arkhe-verify` ou `github:rafael-arkhe/nixpkgs-arkhe?dir=arkhe` após integrar a branch.

## Correções

- Snapshot de fontes explícito em `source/`, com manifesto SHA-256 validando 593 arquivos. O workspace público rafael-arkhe/arkhe tem outra estrutura e não serve como fonte destes pacotes.
- CI na raiz, para master/main e PRs, construindo todos os pacotes e checks.
- Testes nativos do verificador incluem CLI, arkhe-verify-core e arkhe-core.
- Perfil audit instala somente o verificador escolhido; arquivo de ambiente do serviço permanece como caminho de execução, fora do store.
- LF nos arquivos Nix/scripts; bytes originais do snapshot preservados.
- WASM com std do Rust fixado, `lld` explícito e `wasm-bindgen-cli` compatível. Artefato bruto `lib/arkhe-verify.wasm` e bindings Node.js `lib/arkhe_verify.js`.
- WASM incluído em packages/checks. O nome do artefato não implica habilitação da camada PQC.
- Helpers QEMU/KVM para seed de dependências, build em guest e comparação. O seed inclui as dependências próprias do metapacote e exclui os outputs Arkhe.

## Resultado

| Validação | Estado |
|---|---|
| Avaliação x86_64-linux e aarch64-linux | PASS |
| Oito executáveis nativos, WASM e metapacote em x86_64-linux | PASS |
| `nix flake check`, incluindo módulos e smoke tests | PASS |
| Testes nativos do verificador | 81 aprovados |
| WASM executado em Node.js | 20 provas válidas, 106 adulterações recusadas e política malformada recusada |
| Reconstrução local do verificador | Hash idêntico |
| Build CA do verificador | PASS |
| Reprodução dos dez outputs em VM QEMU/KVM | Derivações e hashes NAR idênticos aos do host |

O host usa Nix 2.35.4; a VM usa Nix 2.34.9, NixOS e kernel próprio 6.18.59. Ambos usam o mesmo nixpkgs fixado e Rust 1.99.0. A VM possui discos próprios, sem montagem do store do host. Todos os outputs alvo estavam ausentes antes da compilação; substituição de binários e builders remotos foram desativados.

O ensaio ocorreu no mesmo equipamento físico, com dependências/toolchain comuns. Demonstra reprodução dos outputs especificados neste ambiente fixado. ARM64 foi avaliado, mas os builds executados foram x86_64-linux.

## Evidências

- [Resultados consolidados](validation/results.json)
- [Host: derivações e hashes](validation/full/host-results.json)
- [Comparação final dos dez outputs](validation/vm/comparison.json)
- [Resultados originais da VM](validation/vm/guest/results.json)
- [Seed final sem outputs Arkhe](validation/vm/final-seed/seed-paths.json)
- Logs completos em `validation/full/` e `validation/vm/guest/`.
- [Procedimento para repetir o ensaio](vm-reproduction.md)

Os campos `matches_host: null` em alguns resultados originais da VM refletem hashes do host ainda indisponíveis no início da rodada concorrente. A comparação final foi realizada depois que ambos terminaram e aprovou todos os outputs.

O preparo inicial omitiu `lndir` e `stdenv-linux-no-cc`, dependências exclusivas do metapacote. O helper foi corrigido e o metapacote recompilou com hash idêntico; o log da tentativa inicial foi preservado. Logs `prebuild-*` registram compilações paralelas dentro da mesma VM, após a verificação inicial de ausência dos alvos.

## Escopo

O snapshot é uma cópia de fontes locais, sem release upstream assinado. O template by-name ainda contém fakeHash e exige fonte/revisão/hash reais antes de submissão ao Nixpkgs oficial. Esta camada não implementa boot medido, TPM, IMA nem assinatura híbrida do sistema operacional. As integrações com bancos e serviços externos não foram exercitadas pelos builds.
