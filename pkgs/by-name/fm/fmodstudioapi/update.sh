#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

# Do not put this update script to fmodstudioapi.passthru.updateScript because it needs user input

set -euo pipefail

attr() {
  nix-instantiate --eval -A fmodstudioapi.$1 ${2:+--system $2} --json | jq -r
}

read -p "Enter FMOD username/email: " username
if [[ -z "$username" ]]; then
  echo "Username/email cannot be empty"
  exit 1
fi
read -s -p "Enter FMOD password: " password; echo
if [[ -z "$password" ]]; then
  echo "Password cannot be empty"
  exit 1
fi

auth="$(curl -s -X POST -u "$username:$password" "https://www.fmod.com/api-login" -d "{}")"
token=(-H "Authorization: FMOD $(echo "$auth" | jq -r .token)")
user="$(echo "$auth" | jq -r .user)"
if [[ "$user" == "null" ]]; then
  echo "Login failed"
  exit 1
fi

old_version=$(attr version)
new_version=$(curl -s "https://www.fmod.com/api-downloads" "${token[@]}" \
  | jq -r '.downloads.categories[] | select(.title == "FMOD Engine") | .products[0].versions | max_by(.version) | .version')
if [[ "$new_version" == "$old_version" ]]; then
  echo "Already up to date"
  exit 0
fi

echo "Updating version: $old_version -> $new_version"
nix_file=$(attr meta.position | cut -d : -f 1)
sed -i "s/version = \"$old_version\";/version = \"$new_version\";/" "$nix_file"

for system in x86_64-linux aarch64-darwin; do
  old_hash=$(attr src.outputHash $system)
  name=$(attr src.name $system)
  url="$(curl -s "https://www.fmod.com/api-get-download-link?path=$(attr src.upstreamPath $system)&filename=$name&user_id=$user" "${token[@]}" | jq -r .url)"
  new_hash=$(nix-hash --type sha256 --to-sri $(nix-prefetch-url "$url" --name $name))
  echo "Updating hash: $old_hash -> $new_hash"
  sed -i "s|\"$old_hash\"|\"$new_hash\"|" "$nix_file"
done
