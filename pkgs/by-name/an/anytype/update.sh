#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils curl jq nix-update

set -euo pipefail

anytype_version=null
release_page=1

# Anytype often has many pre-releases between releases, which can span multiple pages
while [ "$anytype_version" = 'null' ]; do
  readarray -t release < <(
    curl "https://api.github.com/repos/anyproto/anytype-ts/releases?page=$release_page" \
      ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} \
      --silent \
    | jq --raw-output '
      map(select(
        (.prerelease == false) and
        (.tag_name | test("alpha|beta") | not)
      )) | .[0] | .tag_name, .created_at
    '
  )
  anytype_version=${release[0]//v}
  anytype_release_date=${release[1]}
  release_page=$((release_page+1))
done

if [ "$UPDATE_NIX_OLD_VERSION" = "$anytype_version" ]; then
  echo "Already up to date!"
  exit 0
fi

# https://github.com/anyproto/anytype-ts/blob/v0.49.2/electron/hook/locale.js
locales_rev=$(
  curl "https://api.github.com/repos/anyproto/l10n-anytype-ts/commits?until=$anytype_release_date&per_page=1" \
    ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} \
    --silent \
  | jq --raw-output '.[0].sha'
)

# https://github.com/anyproto/anytype-ts/blob/v0.49.2/update.sh
middleware_version=$(
  curl "https://raw.githubusercontent.com/anyproto/anytype-ts/refs/tags/v$anytype_version/middleware.version" \
    ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} \
    --silent
)

# https://github.com/anyproto/anytype-heart/blob/v0.42.4/makefiles/vars.mk#L8
tantivy_go_version=$(
  curl "https://raw.githubusercontent.com/anyproto/anytype-heart/refs/tags/v$middleware_version/go.mod" \
    ${GITHUB_TOKEN:+--user ":$GITHUB_TOKEN"} \
    --silent \
  | grep github.com/anyproto/tantivy-go \
  | cut --delimiter=' ' --field=2
)

tantivy_go_version=${tantivy_go_version//v}

nix-update tantivy-go --version "$tantivy_go_version" --generate-lockfile
nix-update anytype-heart --version "$middleware_version"
update-source-version anytype --ignore-same-version --source-key=locales --rev="$locales_rev"
nix-update anytype --version "$anytype_version"
