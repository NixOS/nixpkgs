#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl jq nix

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
sources_file="${script_dir}/sources.nix"

version="$(curl -fsSL "https://dl.enforce.dev/chainctl/latest/metadata.json" | jq -er '.version')"

systems=(
  "aarch64-darwin:darwin_arm64"
  "x86_64-darwin:darwin_x86_64"
  "aarch64-linux:linux_arm64"
  "x86_64-linux:linux_x86_64"
)

{
  printf '{\n'
  printf '  version = "%s";\n\n' "${version}"
  printf '  sources = {\n'

  for system_platform in "${systems[@]}"; do
    system="${system_platform%%:*}"
    platform="${system_platform#*:}"
    url="https://dl.enforce.dev/chainctl/${version}/chainctl_${platform}"
    hash="$(nix store prefetch-file --json "${url}" | jq -r .hash)"

    printf '    %s = {\n' "${system}"
    printf '      url = "%s";\n' "${url}"
    printf '      hash = "%s";\n' "${hash}"
    printf '    };\n'

    if [ "${system}" != "x86_64-linux" ]; then
      printf '\n'
    fi
  done

  printf '  };\n'
  printf '}\n'
} > "${sources_file}"
