channel="stable" # stable/candidate/edge
nixpkgs="$(git rev-parse --show-toplevel)"
spotify_nix="$nixpkgs/pkgs/applications/audio/spotify/default.nix"



# create bash array from snap info
snap_info=($(
	curl -H 'X-Ubuntu-Series: 16' \
		"https://api.snapcraft.io/api/v1/snaps/details/spotify?channel=$channel" \
	| jq --raw-output \
		'.revision,.download_sha512,.version,.last_updated'
))

revision="${snap_info[0]}"
sha512="${snap_info[1]}"
version="${snap_info[2]}"
last_updated="${snap_info[3]}"

# find the last commited version
version_pre=$(
	git  grep 'version\s*=' HEAD "$spotify_nix" \
	| sed -Ene 's/.*"(.*)".*/\1/p'
)

if [[ "$version_pre" = "$version" ]]; then
	echo "Spotify is already up ot date"
	exit 0
fi

echo "Updating from ${version_pre} to ${version}, released on ${last_updated}"

# search-andreplace revision, hash and version
sed --regexp-extended \
	-e 's/rev\s*=\s*"[0-9]+"\s*;/rev = "'"${revision}"'";/' \
	-e 's/sha512\s*=\s*".{128}"\s*;/sha512 = "'"${sha512}"'";/' \
	-e 's/version\s*=\s*".*"\s*;/version = "'"${version}"'";/' \
	-i "$spotify_nix" 

if ! nix-build -A spotify "$nixpkgs"; then
	echo "The updated spotify failed to build."
	exit 1
fi

git add "$spotify_nix"
# show diff for review
git diff HEAD
# prepare commit message, but allow edit
git commit --edit --message "spotify: $version_pre -> $version"
