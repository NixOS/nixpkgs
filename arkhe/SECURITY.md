# Segurança

## Escopo

Este repositório contém **receitas de build** (expressões Nix) para binários do
monorepo Arkhe. Ele não contém chaves, não assina artefatos e não implementa
verificação criptográfica própria — isso é responsabilidade dos crates
`arkhe-verify-*`.

## Como reportar

Abra um advisory privado no repositório Arkhe (GitHub Security Advisories) ou
contate o mantenedor do projeto. Não abra issue pública para falha explorável.

Inclua: atributo afetado (`arkhe-verify`, `arkhe-ask`, ...), versão do
`flake.lock`, comando de build, e o comportamento observado.

## O que conta como vulnerabilidade aqui

- Um pacote que constrói código diferente do fonte declarado.
- Um hash de dependência que não corresponde ao `Cargo.lock`.
- Um caminho de build que reintroduz rede ou resolve versão flutuante.
- Um módulo NixOS que concede privilégio além do necessário.

## O que não conta

- Binário não reproduzível por diferença de `rustc`/`binutils` (é limitação
  conhecida, documentada em `docs/reproducibility.md`).
- Falha de build por falta de serviço externo (PostgreSQL, Kafka).
- Ausência de pacote para componentes que ainda não existem como crate.

## Limites

Estes pacotes não substituem HSM, certificação ICP-Brasil, avaliação de
conformidade ou auditoria independente. Eles entregam binários construídos de
forma reprodutível a partir de fontes fixadas; a confiança no resultado depende
da cadeia de custódia das chaves de release, que está fora deste repositório.
