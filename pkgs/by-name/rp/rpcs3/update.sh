#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure --keep GITHUB_TOKEN -p nix gnused jq nix-prefetch-git curl cacert

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [[ ! "$(basename $ROOT)" == "rpcs3" || ! -f "$ROOT/default.nix" ]]; then
    echo "ERROR: Not in the rpcs3 folder"
    exit 1
fi

if [[ ! -v GITHUB_TOKEN ]]; then
    echo "ERROR: \$GITHUB_TOKEN not set"
    exit 1
fi

payload=$(jq -cn --rawfile query /dev/stdin '{"query": $query}' <<EOF | curl -s -H "Authorization: bearer $GITHUB_TOKEN" -d '@-' https://api.github.com/graphql
{
  repository(owner: "RPCS3", name: "rpcs3") {
    branch: ref(qualifiedName: "refs/heads/master") {
      target {
        oid
        ... on Commit {
          history {
            totalCount
          }
        }
      }
    }

    tag: refs(refPrefix: "refs/tags/", first: 1, orderBy: {field: TAG_COMMIT_DATE, direction: DESC}) {
      nodes {
        name
      }
    }
  }
}
EOF
)

commit_sha=$(jq -r .data.repository.branch.target.oid <<< "$payload")
major_ver=$(jq -r .data.repository.tag.nodes[0].name <<< "$payload" | sed 's/^v//g')
commit_count=$(jq -r .data.repository.branch.target.history.totalCount <<< "$payload")
git_ver="$commit_count-${commit_sha::9}"
final_ver="$major_ver-$git_ver"


echo "INFO: Latest commit is $commit_sha"
echo "INFO: Latest version is $final_ver"

nix_hash=$(nix-prefetch-git --quiet --fetch-submodules https://github.com/RPCS3/rpcs3.git "$commit_sha" | jq -r .sha256)
nix_hash=$(nix hash to-sri --type sha256 "$nix_hash")
echo "INFO: Hash is $nix_hash"

sed -i -E \
    -e "s/rpcs3GitVersion\s*=\s*\"[\.a-z0-9-]+\";$/rpcs3GitVersion = \"${git_ver}\";/g" \
    -e "s/rpcs3Version\s*=\s*\"[\.a-z0-9-]+\";$/rpcs3Version = \"${final_ver}\";/g" \
    -e "s/rpcs3Revision\s*=\s*\"[a-z0-9]+\";$/rpcs3Revision = \"${commit_sha}\";/g" \
    -e "s|rpcs3Hash\s*=\s*\"sha256-.*\";$|rpcs3Hash = \"${nix_hash}\";|g" \
    "$ROOT/package.nix"
