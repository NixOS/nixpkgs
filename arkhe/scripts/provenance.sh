#!/usr/bin/env bash
# Emite um JSON de proveniência para os atributos informados.
#
# Uso: ./scripts/provenance.sh [flake-ref] [atributo...]
#
# Requer `jq` no PATH. O JSON final contém a versão do Nix, os metadados do
# flake (incluindo o locked rev) e, por pacote, caminho, hash do conteúdo e
# endereço CA quando existir.
set -euo pipefail

flake="${1:-.}"
shift || true

attrs=("$@")
if [[ ${#attrs[@]} -eq 0 ]]; then
  attrs=(arkhe-verify)
fi

records="$(mktemp)"
trap 'rm -f "${records}"' EXIT

for attr in "${attrs[@]}"; do
  echo "== ${attr}" >&2
  out="$(nix build "${flake}#${attr}" --no-link --print-out-paths)"
  hash="$(nix hash path "${out}")"
  ca="$(nix path-info --json "${out}" | jq -r '(if type == "array" then .[0] else to_entries[0].value end) | .ca // ""')"

  jq -n \
    --arg attr "${attr}" \
    --arg path "${out}" \
    --arg hash "${hash}" \
    --arg ca "${ca}" \
    '{
      attr: $attr,
      path: $path,
      hash: $hash,
      ca: (if $ca == "" then null else $ca end)
    }' >> "${records}"
done

metadata="$(nix flake metadata "${flake}" --json)"

jq -n \
  --arg nix "$(nix --version)" \
  --argjson flake "${metadata}" \
  --slurpfile packages "${records}" \
  '{
    nix: $nix,
    flake: {
      url: ($flake.url // null),
      revision: ($flake.revision // null),
      locked: ($flake.locked // null)
    },
    packages: $packages
  }'
