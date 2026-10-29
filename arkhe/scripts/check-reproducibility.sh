#!/usr/bin/env bash
# Verifica se um pacote reconstrói com o mesmo conteúdo.
#
# Uso: ./scripts/check-reproducibility.sh [atributo] [flake-ref]
#
# `nix build --rebuild` reconstrói o derivado e compara o conteúdo produzido
# com o que já está no store. Se o hash mudar, o comando falha.
set -euo pipefail

attr="${1:-arkhe-verify}"
flake="${2:-.}"

echo "== build inicial: ${flake}#${attr}"
out="$(nix build "${flake}#${attr}" --no-link --print-out-paths)"
first="$(nix hash path "${out}")"
echo "hash1=${first}"

echo "== rebuild forçado (--rebuild)"
nix build "${flake}#${attr}" --rebuild --option substitute false --no-link --print-out-paths > /dev/null
second="$(nix hash path "${out}")"
echo "hash2=${second}"

if [[ "${first}" != "${second}" ]]; then
  echo "NAO REPRODUTIVEL: ${attr} (${first} != ${second})" >&2
  exit 1
fi

echo "REPRODUZIVEL: ${attr} ${first}"
