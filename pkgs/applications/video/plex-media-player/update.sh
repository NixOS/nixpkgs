#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl common-updater-scripts nix-prefetch-scripts jq
# shellcheck shell=bash

set -xeuo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"

oldVersion="$(nix-instantiate --eval -E "with import $nixpkgs {}; plex-media-player.version or (builtins.parseDrvName plex-media-player.name).version" | tr -d '"')"
latestTag="$(curl -s https://api.github.com/repos/plexinc/plex-media-player/tags  | jq -r '.[] | .name' | sort --version-sort | tail -1)"
latestVersion="$(expr $latestTag : 'v\(.*\)-.*')"
latestHash="$(expr $latestTag : 'v.*-\(.*\)')"

if [ ! "$oldVersion" = "$latestVersion" ]; then
  # update default.nix with the new version and hash
  expectedHash=$(nix-prefetch-git --url https://github.com/plexinc/plex-media-player.git --rev $latestTag --quiet | jq -r '.sha256')
  update-source-version plex-media-player --version-key=vsnHash "${latestHash}" 0000
  update-source-version plex-media-player "${latestVersion}" $expectedHash

  # extract the webClientBuildId from the source folder
  src="$(nix-build --no-out-link $nixpkgs -A plex-media-player.src)"
  webClientBuildId="$(grep 'set(WEB_CLIENT_BUILD_ID' $src/CMakeModules/WebClient.cmake | cut -d' ' -f2 | tr -d ')')"

  # retreive the included cmake file and hash
  { read -r webClientBuildIdHash; read -r webClientBuildIdPath; } < \
    <(nix-prefetch-url --print-path "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/buildid.cmake")
  webClientDesktopBuildId="$(grep 'set(DESKTOP_VERSION' $webClientBuildIdPath | cut -d' ' -f2 | tr -d ')')"
  webClientTvBuildId="$(grep 'set(TV_VERSION' $webClientBuildIdPath | cut -d' ' -f2 | tr -d ')')"

  # get the hashes for the other files
  webClientDesktopHash="$(nix-prefetch-url "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz.sha1")"
  webClientDesktop="$(nix-prefetch-url "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-desktop-${webClientDesktopBuildId}.tar.xz")"
  webClientTvHash="$(nix-prefetch-url "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz.sha1")"
  webClientTv="$(nix-prefetch-url "https://artifacts.plex.tv/web-client-pmp/${webClientBuildId}/web-client-tv-${webClientTvBuildId}.tar.xz")"

  # update deps.nix
  cat > $nixpkgs/pkgs/applications/video/plex-media-player/deps.nix <<EOF
{ fetchurl }:

rec {
  webClientBuildId = "${webClientBuildId}";
  webClientDesktopBuildId = "${webClientDesktopBuildId}";
  webClientTvBuildId = "${webClientTvBuildId}";

  webClient = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/\${webClientBuildId}/buildid.cmake";
    sha256 = "${webClientBuildIdHash}";
  };
  webClientDesktopHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/\${webClientBuildId}/web-client-desktop-\${webClientDesktopBuildId}.tar.xz.sha1";
    sha256 = "${webClientDesktopHash}";
  };
  webClientDesktop = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/\${webClientBuildId}/web-client-desktop-\${webClientDesktopBuildId}.tar.xz";
    sha256 = "${webClientDesktop}";
  };
  webClientTvHash = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/\${webClientBuildId}/web-client-tv-\${webClientTvBuildId}.tar.xz.sha1";
    sha256 = "${webClientTvHash}";
  };
  webClientTv = fetchurl {
    url = "https://artifacts.plex.tv/web-client-pmp/\${webClientBuildId}/web-client-tv-\${webClientTvBuildId}.tar.xz";
    sha256 = "${webClientTv}";
  };
}
EOF

  git add "$nixpkgs"/pkgs/applications/video/plex-media-player/{default,deps}.nix
  git commit -m "plex-media-player: ${oldVersion} -> ${latestVersion}"
else
  echo "plex-media-player is already up-to-date"
fi
