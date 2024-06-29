#!/usr/bin/env nix-shell
#! nix-shell -i oil -p jq moreutils nix-prefetch-github gnused

# TODO set to `verbose` or `extdebug` once implemented in oil
shopt --set xtrace
# we need failures inside of command subs to get the correct cargoHash
shopt --unset inherit_errexit

const directory = $(dirname $0 | xargs realpath)
const owner = "solana-labs"
const repo = "solana"
const latest_rev = $(curl -q https://api.github.com/repos/${owner}/${repo}/releases/latest | \
  jq -r '.tag_name')
const latest_version = $(echo ${latest_rev#v})
const current_version = $(jq -r '.version' $directory/pin.json)
if ("$latest_version" === "$current_version") {
  echo "solana is already up-to-date"
  return 0
} else {
  const tarball_meta = $(nix-prefetch-github $owner $repo --rev "$latest_rev")
  const tarball_hash = $(echo $tarball_meta | jq -r '.hash')

  jq ".version = \"$latest_version\" | \
      .\"hash\" = \"$tarball_hash\" | \
      .\"cargoHash\" = \"\"" $directory/pin.json | sponge $directory/pin.json

  const new_cargo_hash = $(nix-build -A solana-validator 2>&1 | \
    tail -n 2 | \
    head -n 1 | \
    sed 's/\s*got:\s*//')

  jq ".cargoHash = \"$new_cargo_hash\"" $directory/pin.json | sponge $directory/pin.json
}
