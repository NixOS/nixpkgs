#!/usr/bin/env bash
# Verifica que uma derivação produzida em modo CA tem endereço de conteúdo.
#
# Uso: ./scripts/verify-content-addressing.sh [atributo] [flake-ref]
#
# Requer as features experimentais `ca-derivations` e `jq` no PATH.
set -euo pipefail

attr="${1:-arkhe-verify}"
flake="${2:-.}"

features="nix-command flakes ca-derivations"
system="$(nix eval --raw --impure --expr builtins.currentSystem)"
ref="${flake}#legacyPackages.${system}.ca.${attr}"

echo "== build CA: ${ref}"
out="$(nix build "${ref}" --no-link --print-out-paths \
  --extra-experimental-features "${features}")"

ca="$(nix path-info --json "${out}" \
  --extra-experimental-features "${features}" \
  | jq -r '(if type == "array" then .[0] else to_entries[0].value end) | .ca // empty')"

if [[ -z "${ca}" ]]; then
  echo "SEM ENDERECO DE CONTEUDO: ${out}" >&2
  exit 1
fi

echo "CONTEUDO ENDERECADO: ${attr} ca=${ca} path=${out}"
