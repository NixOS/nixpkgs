#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq
set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
castopod_nix="$nixpkgs/pkgs/applications/audio/castopod/default.nix"

# https://www.meetup.com/api/guide/#p02-querying-section
query='
query allReleases($fullPath: ID!, $first: Int, $last: Int, $before: String, $after: String, $sort: ReleaseSort) {
  project(fullPath: $fullPath) {
    id
    releases(
      first: $first
      last: $last
      before: $before
      after: $after
      sort: $sort
    ) {
      nodes {
        ...Release
        __typename
      }
      __typename
    }
    __typename
  }
}

fragment Release on Release {
  id
  name
  tagName
  releasedAt
  createdAt
  upcomingRelease
  historicalRelease
  assets {
    links {
      nodes {
        id
        name
        url
        directAssetUrl
        linkType
        __typename
      }
      __typename
    }
    __typename
  }
  __typename
}
'
variables='{
  "fullPath": "adaures/castopod",
  "first": 1,
  "sort": "RELEASED_AT_DESC"
}'

post=$(cat <<EOF
{"query": "$(echo $query)", "variables": $(echo $variables)}
EOF
)

json="$(curl -s -X POST https://code.castopod.org/api/graphql \
  -H 'Content-Type: application/json' \
  -d "$post")"

echo "$json"
TAG=$(echo $json | jq -r '.data.project.releases.nodes[].tagName')
ASSET_URL=$(echo $json | jq -r '.data.project.releases.nodes[].assets.links.nodes[].url' | grep .tar.gz$)

CURRENT_VERSION=$(nix eval -f "$nixpkgs" --raw castopod.version)
VERSION=${TAG:1}

if [[ "$CURRENT_VERSION" == "$VERSION" ]]; then
  echo "castopod is up-to-date: ${CURRENT_VERSION}"
  exit 0
fi

SHA256=$(nix-prefetch-url "$ASSET_URL")

URL=$(echo $ASSET_URL | sed -e 's/[\/&]/\\&/g')

sed -e "s/version =.*;/version = \"$VERSION\";/g" \
    -e "s/url =.*;/url = \"$URL\";/g" \
    -e "s/sha256 =.*;/sha256 = \"$SHA256\";/g" \
    -i "$castopod_nix"
