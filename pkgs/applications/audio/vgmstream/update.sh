#!/usr/bin/env nix-shell
#!nix-shell -i bash --pure --keep GITHUB_TOKEN -p gnused jq nix-prefetch-git curl cacert

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [[ ! "$(basename $ROOT)" == "vgmstream" || ! -f "$ROOT/default.nix" ]]; then
    echo "ERROR: Not in the vgmstream folder"
    exit 1
fi

if [[ ! -v GITHUB_TOKEN ]]; then
    echo "ERROR: \$GITHUB_TOKEN not set"
    exit 1
fi


payload=$(jq -cn --rawfile query /dev/stdin '{"query": $query}' <<EOF | curl -s -H "Authorization: bearer $GITHUB_TOKEN" -d '@-' https://api.github.com/graphql
{
  repository(owner: "vgmstream", name: "vgmstream") {
    branch: ref(qualifiedName: "refs/heads/master") {
      target {
        oid
        ... on Commit {
          committedDate
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

committed_full_date=$(jq -r .data.repository.branch.target.committedDate <<< "$payload")
committed_date=$(sed -nE 's/^([0-9]{4}-[0-9]{2}-[0-9]{2}).+$/\1/p' <<< $committed_full_date)
commit_unix=$(date --utc --date="$committed_date" +%s)
last_updated_unix=$(date --utc --date=$(sed -nE 's/^\s*version\s*=\s*\"unstable-([0-9]{4}-[0-9]{2}-[0-9]{2})\";$/\1/p' default.nix) +%s)

commit_sha=$(jq -r .data.repository.branch.target.oid <<< "$payload")
major_ver=$(jq -r .data.repository.tag.nodes[0].name <<< "$payload" | sed 's/^v//g')
commit_count=$(jq -r .data.repository.branch.target.history.totalCount <<< "$payload")
final_ver="$major_ver-$commit_count-${commit_sha::9}"


echo "INFO: Latest commit is $commit_sha"
echo "INFO: Latest commit date is $committed_full_date"
echo "INFO: Latest version is $final_ver"

##
# VGMStream has no stable releases, so only update if there's been at
# least a week between commits to reduce maintainer pressure.
##
time_diff=$(( $commit_unix - $last_updated_unix ))
if [[ $time_diff -lt 604800 ]]; then
  echo "INFO: Not updating, less than a week between commits."
  echo "INFO: $time_diff < 604800"
  exit 0
fi

nix_sha256=$(nix-prefetch-git --quiet https://github.com/vgmstream/vgmstream.git "$commit_sha" | jq -r .sha256)
echo "INFO: SHA256 is $nix_sha256"

sed -i -E \
    -e "s/vgmstreamVersion\s*=\s*\"[a-z0-9-]+\";$/vgmstreamVersion = \"${final_ver}\";/g" \
    -e "s/version\s*=\s*\"[a-z0-9-]+\";$/version = \"unstable-${committed_date}\";/g" \
    -e "s/rev\s*=\s*\"[a-z0-9]+\";$/rev = \"${commit_sha}\";/g" \
    -e "s/sha256\s*=\s*\"[a-z0-9]+\";$/sha256 = \"${nix_sha256}\";/g" \
    "$ROOT/default.nix"
