#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git -p jq
# shellcheck shell=bash

imlist=(
    array
    bopomofo
    cangjie
    cantonese
    combo-pinyin
    double-pinyin
    emoji
    essay
    ipa
    jyutping
    luna-pinyin
    middle-chinese
    pinyin-simp
    prelude
    quick
    scj
    soutzoe
    stenotype
    stroke
    terra-pinyin
    wubi
    wugniu
)

echo "# Generated using generateFetchSchema.sh"
echo "fetchFromGitHub:"
echo \'\'
echo "mkdir -p package/rime"
for im in ${imlist[@]}; do
    tempFile=$(mktemp)
    echo "ln -sv \${fetchFromGitHub {"
    echo "  owner = \"rime\";"
    echo "  repo = \"rime-$im\";"
    nix-prefetch-git --quiet https://github.com/rime/rime-$im \
        | jq '{ rev: .rev, sha256: .sha256 }' \
        | jq -r 'to_entries | map("  \(.key) = \"\(.value)\";") | .[]'
    echo "}} package/rime/$im"
done
echo \'\'
