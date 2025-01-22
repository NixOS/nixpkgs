#!/usr/bin/env bash

set -euo pipefail

# https://stackoverflow.com/a/246128/6605742
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Allows using a local directory for temporary files,
# which can then be inspected after the run
if (( $# > 0 )); then
    tmp=$(realpath "$1/tmp")
    if [[ -e "$tmp" ]]; then
        rm -rf "$tmp"
    fi
    mkdir -p "$tmp"
else
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' exit
fi

# Tests a scenario where two poorly formatted files were modified on both the
# main branch and the feature branch, while the main branch also did a treewide
# format.

git init "$tmp/repo"
cd "$tmp/repo" || exit
git branch -m main

# Some initial poorly-formatted files
cat > a.nix <<EOF
{ x
, y

, z
}:
null
EOF

cat > b.nix <<EOF
{
  this = "is";


  some="set" ;
 }
EOF

git add -A
git commit -m "init"

git switch -c feature

# Some changes
sed 's/set/value/' -i b.nix
git commit -a -m "change b"
sed '/, y/d' -i a.nix
git commit -a -m "change a"

git switch main

# A change to cause a merge conflict
sed 's/y/why/' -i a.nix
git commit -a -m "change a"

cat > treefmt.toml <<EOF
[formatter.nix]
command = "nixfmt"
includes = [ "*.nix" ]
EOF
git add -A
git commit -a -m "introduce treefmt"

# Treewide reformat
treefmt
git commit -a -m "format"

echo "$(git rev-parse HEAD) # !autorebase treefmt" > .git-blame-ignore-revs
git add -A
git commit -a -m "update ignored revs"

git switch feature

# Setup complete

git log --graph --oneline feature main

# This expectedly fails with a merge conflict that has to be manually resolved
"$SCRIPT_DIR"/../run.sh main && exit 1
sed '/<<</,/>>>/d' -i a.nix
git add a.nix
GIT_EDITOR=true git rebase --continue

"$SCRIPT_DIR"/../run.sh main

git log --graph --oneline feature main

checkDiff() {
    local ref=$1
    local file=$2
    expectedDiff=$(cat "$file")
    actualDiff=$(git diff "$ref"~ "$ref")
    if [[ "$expectedDiff" != "$actualDiff" ]]; then
        echo -e "Expected this diff:\n$expectedDiff"
        echo -e "But got this diff:\n$actualDiff"
        exit 1
    fi
}

checkDiff HEAD~ "$SCRIPT_DIR"/first.diff
checkDiff HEAD "$SCRIPT_DIR"/second.diff

echo "Success!"
