#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bundler-audit

set -o errexit -o nounset -o pipefail

bundle-audit check "$(nix-build --no-out-link maintainers/scripts/audit-ruby-packages/default.nix)"
