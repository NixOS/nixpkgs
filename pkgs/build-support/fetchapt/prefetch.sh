#!/bin/sh -e
NIX_REMOTE=daemon "${nix}/bin/nix-prefetch-url" \
  --type sha256 --print-path "${url}" \
  | { read hash ; read store ; echo -n "${store}" > "${out}" ; }
