#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix nix-update curl dpkg jdk_headless gnugrep
set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)";
cd "$nixpkgs";

nix-update nuvio-desktop --version=unstable;

# extract local.properties from deb
version="$(nix-instantiate --eval --raw -A nuvio-desktop.version)";
tmp="$(mktemp -d)";
trap 'rm -rf "$tmp"' EXIT;
curl -fsSL -o "$tmp/nuvio.deb" "https://github.com/NuvioMedia/NuvioDesktop/releases/download/$version/Nuvio-Linux-x86_64-$version.deb";
dpkg-deb --fsys-tarfile "$tmp/nuvio.deb" \
  | tar -xO --wildcards '*/composeApp-desktop-*.jar' \
  > "$tmp/app.jar";
while read -r class env_prefix; do
  javap -constants -cp "$tmp/app.jar" "com.nuvio.app.$class" \
    | sed -nE "s/.* java\.lang\.String (\w+) = \"(.*)\";$/$env_prefix\1=\2/p";
done > pkgs/by-name/nu/nuvio-desktop/local.properties <<EOF
core.network.SupabaseConfig NUVIO_SUPABASE_
features.trakt.TraktConfig TRAKT_
features.simkl.SimklConfig SIMKL_
features.tmdb.TmdbConfig TMDB_
features.mdblist.MdbListConfig MDBLIST_
features.discordrpc.DiscordConfig NUVIO_DISCORD_
features.player.skip.IntroDbConfig INTRODB_API_
features.details.ImdbEpisodeRatingsConfig
features.debrid.PremiumizeConfig PREMIUMIZE_
features.settings.CommunityConfig
core.diagnostics.SentryConfig SENTRY_
EOF
