#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p nix nix-prefetch-git coreutils curl jq gnused

set -euo pipefail

# Will be replaced with the actual branch when running this from passthru.updateScript
BRANCH="@branch@"
DEFAULT_NIX="$(dirname "${BASH_SOURCE[@]}")/default.nix"

if [[ "$(basename "$PWD")" = "yuzu" ]]; then
    echo "error: Script must be ran from nixpkgs's root directory for compatibility with the maintainer script"
    exit 1
fi

updateBranch() {
    local branch attribute oldVersion oldHash newVersion newHash
    branch="$1"
    attribute="yuzu-$branch"
    [[ "$branch" = "early-access" ]] && attribute="yuzu-ea" # Attribute path doesnt match the branch name
    oldVersion="$(nix eval --raw -f "./default.nix" "$attribute".version)"
    oldHash="$(nix eval --raw -f "./default.nix" "$attribute".src.drvAttrs.outputHash)"

    if [[ "$branch" = "mainline" ]]; then
        newVersion="$(curl -s ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/yuzu-emu/yuzu-mainline/releases?per_page=1" \
            | jq -r '.[0].name' | cut -d" " -f2)"
    elif [[ "$branch" = "early-access" ]]; then
        newVersion="$(curl -s ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/pineappleEA/pineapple-src/releases?per_page=2" \
            | jq -r '.[].tag_name' | grep '^EA-[0-9]*' | head -n1 | cut -d"-" -f2 | cut -d" " -f1)"
    fi

    if [[ "${oldVersion}" = "${newVersion}" ]]; then
        echo "$attribute is already up to date."
        return
    else
        echo "$attribute: ${oldVersion} -> ${newVersion}"
    fi

    echo "  fetching source code to generate hash..."
    if [[ "$branch" = "mainline" ]]; then
        newHash="$(nix-prefetch-git --quiet --fetch-submodules --rev "mainline-0-${newVersion}" "https://github.com/yuzu-emu/yuzu-mainline" | jq -r '.sha256')"
    elif [[ "$branch" = "early-access" ]]; then
        newHash="$(nix-prefetch-git --quiet --fetch-submodules --rev "EA-${newVersion}" "https://github.com/pineappleEA/pineapple-src" | jq -r '.sha256')"
    fi
    newHash="$(nix hash to-sri --type sha256 "${newHash}")"

    sed -i "s,${oldVersion},${newVersion}," "$DEFAULT_NIX"
    sed -i "s,${oldHash},${newHash},g" "$DEFAULT_NIX"
    echo "  succesfully updated $attribute. new hash: $newHash"
}

updateCompatibilityList() {
    local latestRevision oldUrl newUrl oldHash newHash oldDate newDate
    latestRevision="$(curl -s ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/flathub/org.yuzu_emu.yuzu/commits/master" | jq -r '.sha')"

    oldUrl="$(sed -n '/yuzu-compat-list/,/url/p' "$DEFAULT_NIX" | tail -n1 | cut -d'"' -f2)"
    newUrl="https://raw.githubusercontent.com/flathub/org.yuzu_emu.yuzu/${latestRevision}/compatibility_list.json"

    oldDate="$(sed -n '/last updated.*/p' "$DEFAULT_NIX" | rev | cut -d' ' -f1 | rev)"
    newDate="$(curl -s ${GITHUB_TOKEN:+"-u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/flathub/org.yuzu_emu.yuzu/commits/${latestRevision}" \
        | jq -r '.commit.committer.date' | cut -d'T' -f1)"

    oldHash="$(sed -n '/yuzu-compat-list/,/sha256/p' "$DEFAULT_NIX" | tail -n1 | cut -d'"' -f2)"
    newHash="$(nix hash to-sri --type sha256 "$(nix-prefetch-url --quiet "$newUrl")")"

    if [[ "$oldHash" = "$newHash" ]]; then
        echo "compatibility_list is already up to date."
        return
    else
        echo "compatibility_list: $oldDate -> $newDate"
    fi

    sed -i "s,${oldUrl},${newUrl},g" "$DEFAULT_NIX"
    sed -i "s,${oldHash},${newHash},g" "$DEFAULT_NIX"
    sed -i "s,${oldDate},${newDate},g" "$DEFAULT_NIX"
    echo "  succesfully updated compatibility_list. new hash: $newHash"
}

if [[ "$BRANCH" = "mainline" ]] || [[ "$BRANCH" = "early-access" ]]; then
    updateBranch "$BRANCH"
    updateCompatibilityList
else # Script is not ran from passthru.updateScript
    if (( $# == 0 )); then
        updateBranch "mainline"
        updateBranch "early-access"
    fi

    while (( "$#" > 0 )); do
        case "$1" in
            mainline|yuzu-mainline)
                updateBranch "mainline"
                ;;
            early-access|yuzu-early-access|ea|yuzu-ea)
                updateBranch "early-access"
                ;;
            *)
                echo "error: invalid branch: $1."
                echo "usage: $(basename "$0") [mainline|early-access]"
                exit 1
                ;;
        esac
        shift
    done

    updateCompatibilityList
fi
