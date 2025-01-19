#!/usr/bin/env nix-shell
#! nix-shell -i bash --keep GITHUB_TOKEN -p nix-prefetch jq

set -eo pipefail

curl_args=( '--silent' )

# optionally takes a GITHUB_TOKEN to overcome api rate limiting.
if [ -n "$GITHUB_TOKEN" ]; then curl_args+=( --header "authorization: Bearer ${GITHUB_TOKEN}" ); fi

# get latest release assets
curl_args+=( --url https://api.github.com/repos/adi1090x/plymouth-themes/releases/latest )
theme_archives=$(curl "${curl_args[@]}" | jq -r '.assets' )

dirname="$(dirname "$0")"

printf '{\n' > "$dirname/shas.nix"

while
  read -r file_path
do
    name="$(basename $file_path)"
    name="${name/.tar.gz/}"

    printf '  "%s" = {\n    url = "%s";\n    sha = "%s";\n  };\n' "${name}" "$file_path" "$(nix-prefetch-url "$file_path")" >>"$dirname/shas.nix"
done < <(jq -r '.[].browser_download_url' <<<"$theme_archives")

printf '}\n' >> "$dirname/shas.nix"
