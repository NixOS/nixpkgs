#!/usr/bin/env bash
# Reconstrói pacotes já construídos e exige saída idêntica bit a bit.
#
# Uso: [FLAKE=.] ./scripts/check-reproducibility.sh [atributo...]
#
# `nix build --rebuild` constrói a derivação de novo, sem substituto, e
# compara com a saída que já está no store. Se diferir, o Nix falha e, com
# `--keep-failed`, deixa a segunda saída em `<out>.check` para diffoscope.
#
# Complementa o check `reproducible-*` do flake: aqui a comparação é contra a
# mesma saída registrada no store (mesmo caminho), não contra uma variante.
set -euo pipefail

flake="${FLAKE:-.}"
if [[ $# -eq 0 ]]; then
  set -- arkhe-verify arkhe-verify-wasm arkhe-sdd-parser
fi

failed=0
for attr in "$@"; do
  echo "== ${flake}#${attr}: build inicial"
  out="$(nix build "${flake}#${attr}" --no-link --print-out-paths)"
  hash="$(nix hash path "${out}")"

  echo "== ${flake}#${attr}: --rebuild"
  if nix build "${flake}#${attr}" --rebuild --keep-failed --option substitute false --no-link; then
    echo "REPRODUZIVEL ${attr} ${hash} ${out}"
  else
    failed=1
    echo "NAO REPRODUTIVEL ${attr} ${out}" >&2
    if [[ -e "${out}.check" ]]; then
      echo "  compare: diffoscope ${out} ${out}.check" >&2
    fi
  fi
done

exit "${failed}"
