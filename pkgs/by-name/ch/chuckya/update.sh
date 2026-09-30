#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update common-updater-scripts gnused bundix yarn-berry_4.yarn-berry-fetcher nixfmt

set -euo pipefail

pkgdir="pkgs/by-name/ch/chuckya"

nix-update chuckya --src-only --version=branch --override-filename "$pkgdir/package.nix"

# tags haven't been created since 2017, so it doesn't make sense to use this one as the base version
sed -i -E 's/version = "1\.2\.2-unstable/version = "0-unstable/' "$pkgdir/package.nix"

src="$(nix-build --no-out-link -A chuckya.src)"
bundix --lockfile="$src/Gemfile.lock" --gemfile="$src/Gemfile" --gemset="$pkgdir/gemset.nix"
nixfmt "$pkgdir/gemset.nix"
yarn-berry-fetcher missing-hashes "$src/yarn.lock" > "$pkgdir/missing-hashes.json"
update-source-version chuckya --source-key=mastodonModules.yarnOfflineCache --ignore-same-version --file="$pkgdir/package.nix"
