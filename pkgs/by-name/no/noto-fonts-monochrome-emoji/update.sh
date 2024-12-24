#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts git nix-prefetch

tmpdir=$(mktemp -d)

git -C "$tmpdir" init --initial-branch main
git -C "$tmpdir" config core.sparseCheckout true
git -C "$tmpdir" remote add origin https://github.com/google/fonts.git
echo "ofl/notoemoji/*" > "$tmpdir/.git/info/sparse-checkout"
git -C "$tmpdir" fetch origin main
git -C "$tmpdir" checkout main

newrev=$(git -C "$tmpdir" rev-list -1 HEAD "ofl/notoemoji/*.ttf")
newver=$(grep 'archive:' "$tmpdir/ofl/notoemoji/upstream.yaml" | grep -oP '(?<=v)[0-9]+\.[0-9]+')
newhash=$(nix-prefetch "{ stdenv, fetchurl }: stdenv.mkDerivation rec {
  name = \"noto-fonts-cjk-serif\";
  src = fetchFromGitHub {
    owner = \"google\";
    repo = \"fonts\";
    rev = \"$newrev\";
    sparseCheckout = [ \"ofl/notoemoji\" ];
  };
}")

update-source-version noto-fonts-monochrome-emoji "$newver" "$newhash" --rev="$newrev"
