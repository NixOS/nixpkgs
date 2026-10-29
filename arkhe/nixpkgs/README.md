# Submissão ao nixpkgs

`by-name/` contém o template no formato exigido pelo nixpkgs atual:
`pkgs/by-name/<duas primeiras letras>/<nome>/package.nix`.

## Por que é um template

O nixpkgs exige que a fonte seja baixada de uma URL fixa e verificada por hash.
Este repositório ainda não tem uma tag de release pública com hash calculável,
então o template usa `lib.fakeHash` — ele falha de forma explícita, em vez de
esconder um hash inventado.

## Passos para abrir o PR

1. Publicar uma tag `v0.1.0` do monorepo Arkhe.
2. Calcular o hash da fonte:
   ```bash
   nix-prefetch-github rafael-arkhe arkhe --rev v0.1.0
   ```
3. Substituir `lib.fakeHash` pelo valor SRI em
   `by-name/ar/arkhe-verify/package.nix`.
4. Copiar o diretório para um checkout do nixpkgs e validar:
   ```bash
   nix-build -A arkhe-verify
   nixpkgs-review pr <numero>
   ```
5. Adicionar um mantenedor real em `meta.maintainers` (o nixpkgs exige uma
   entrada em `maintainers/maintainer-list.nix`) e uma entrada em
   `pkgs/top-level/all-packages.nix` **não é necessária** no layout `by-name`.

## Escopo

Somente `arkhe-verify` está preparado para submissão. Os demais pacotes
(`arkhe-runtime`, `arkhe-ask`, `arkhe-sql-migrate`, `arkhe-twin`,
`arkhe-ollama`, `arkhe-crm-bridge`, `arkhe-python-gate`) dependem de serviços
externos em tempo de execução e ainda não têm testes herméticos que justifiquem
entrar no nixpkgs.
