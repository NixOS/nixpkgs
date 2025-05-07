#!/usr/bin/env nix-shell
#! nix-shell -i bash --keep GITHUB_TOKEN -p nix-prefetch jq

set -eo pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

curl_args=( '--silent' )

# optionally takes a GITHUB_TOKEN to overcome api rate limiting.
if [ -n "$GITHUB_TOKEN" ]; then curl_args+=( --header "authorization: Bearer ${GITHUB_TOKEN}" ); fi

# get latest release assets
curl_args+=( --url https://api.github.com/repos/adi1090x/plymouth-themes/releases/latest )
theme_archives=$(curl "${curl_args[@]}" | jq -r '.assets' )

printf '{\n' > "${SCRIPT_DIRECTORY}/shas.nix"

while
  read -r file_path
do
    name="$(basename $file_path)"
    name="${name/.tar.gz/}"

    printf '  "%s" = {\n    url = "%s";\n    sha = "%s";\n  };\n' "${name}" "$file_path" "$(nix-prefetch-url "$file_path")" >>"${SCRIPT_DIRECTORY}/shas.nix"
done < <(jq -r '.[].browser_download_url' <<<"$theme_archives")

printf '}\n' >> "${SCRIPT_DIRECTORY}/shas.nix"
