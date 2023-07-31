#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git nix

set -eou pipefail
shopt -s extglob

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 [--in-current-worktree] [PR number] attrPath..." >&2
    echo "Attribute paths are optional only if PR is specified" >&2
    exit 1
fi

nixpkgsRemote=https://github.com/NixOS/nixpkgs.git

inCurrentWorktree=
if [[ "$1" == --in-current-worktree ]]; then
    inCurrentWorktree=y
    shift
fi

pr=
if [[ "$1" =~ ^[1-9] ]]; then
    pr=$1
    shift
fi
attrPaths=("$@")

cleanupHooks=()
function cleanup {
    for ((i = ${#cleanupHooks[@]} - 1; i >= 0; i--)); do
        ${cleanupHooks[$i]}
    done
}
trap cleanup EXIT

function mkWorktree {
    if [[ "$inCurrentWorktree" ]]; then
        worktree=$PWD
    else
        worktree=$(mktemp -d)
        cleanupHooks+=(rmWorktree)
    fi
}

function rmWorktree {
    cd
    rm -rf "$worktree"
}

function mkGitWorktree {
    if [[ "$inCurrentWorktree" ]]; then
        git checkout --quiet --detach "$1"
        cleanupHooks+=(revertGitCheckout)
    else
        git worktree add --quiet -d "$worktree" "$1"
        cleanupHooks+=(rmGitWorktree)
    fi
}

function rmGitWorktree {
    git worktree remove -f "$worktree"
}

function revertGitCheckout {
    git checkout --quiet -
}

function mkBareSrcDir {
    bareSrcDir=$(mktemp -u)
    cleanupHooks+=(rmBareSrcDir)
}

function rmBareSrcDir {
    rm -rf "$bareSrcDir"
}

if [[ "$pr" ]]; then
    mkWorktree
    git fetch --quiet "$nixpkgsRemote" "pull/$pr/head"
    mkGitWorktree FETCH_HEAD
    cd "$worktree"
    if [[ "$inCurrentWorktree" ]]; then
        mkBareSrcDir
    else
        mkdir .src
        bareSrcDir="$worktree/.src"
    fi

    if [[ "${#attrPaths[@]}" == 0 ]]; then
        git fetch --quiet "$nixpkgsRemote" master
        readarray -t attrPaths < <(git log --format=%s FETCH_HEAD..HEAD | cut -s -f1 -d:)
    fi
else
    mkBareSrcDir
fi

suggestions=
for attrPath in "${attrPaths[@]}"; do
    IFS=$'\t' read -r curVer gitRepoUrl rev < <(nix eval --extra-experimental-features nix-command --impure --raw --expr "with import ./. {}; \"\${$attrPath.version}\\t\${$attrPath.src.gitRepoUrl or \"-\"}\\t\${$attrPath.src.rev}\\n\"")
    if ! [[ "$curVer" =~ unstable ]]; then
        echo "$attrPath version $curVer is not unstable" >&2
    elif [[ "$gitRepoUrl" == - ]]; then
        echo "$attrPath doesn't fetch from a Git repository" >&2
    else
        git clone --quiet --bare "$gitRepoUrl" "$bareSrcDir"
        verPart=$(GIT_DIR=$bareSrcDir git describe --tags --always --candidates=50 "$rev")
        if [[ "$verPart" =~ - ]]; then
            verPart=${verPart##*([^0-9])}
            # Chop the commit abbreviation
            verPart=${verPart%-*}
            # Then chop the number of commits since the tag
            verPart=${verPart%-*}
        else
            verPart=0
        fi
        datePart=$(GIT_DIR=$bareSrcDir git show -s --format="%cs" "$rev")
        suggestVer=$verPart-unstable-$datePart
        if [[ "$curVer" == "$suggestVer" ]]; then
            echo "$attrPath version $curVer looks correct" >&2
        else
            echo "$attrPath version $curVer should perhaps be $suggestVer"
            suggestions=y
        fi
        rm -rf "$bareSrcDir"
    fi
done

if [[ "$suggestions" ]]; then
    exit 2
fi
