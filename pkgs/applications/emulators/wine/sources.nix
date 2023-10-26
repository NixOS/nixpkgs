{ pkgs ? import <nixpkgs> {} }:
## we default to importing <nixpkgs> here, so that you can use
## a simple shell command to insert new hashes into this file
## e.g. with emacs C-u M-x shell-command
##
##     nix-prefetch-url sources.nix -A {stable{,.mono,.gecko64,.gecko32}, unstable, staging, winetricks}

# here we wrap fetchurl and fetchFromGitHub, in order to be able to pass additional args around it
let fetchurl = args@{url, hash, ...}:
  pkgs.fetchurl { inherit url hash; } // args;
    fetchFromGitHub = args@{owner, repo, rev, hash, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev hash; } // args;
    fetchFromGitLab = args@{domain, owner, repo, rev, hash, ...}:
  pkgs.fetchFromGitLab { inherit domain owner repo rev hash; } // args;

    updateScriptPreamble = ''
      set -eou pipefail
      PATH=${with pkgs; lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep gnused jq nix ]}
      sources_file=${__curPos.file}
      source ${./update-lib.sh}
    '';

    inherit (pkgs) writeShellScript;
in rec {

  stable = fetchurl rec {
    version = "8.0.2";
    url = "https://dl.winehq.org/wine/source/8.0/wine-${version}.tar.xz";
    hash = "sha256-bsj7byxy1XbLEfUrL41Zr2RASAIVRlHRIrmEZtkdyEc=";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.47.3";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86.msi";
      hash = "sha256-5bmwbTzjVWRqjS5y4ETjfh4MjRhGTrGYWtzRh6f0jgE=";
    };
    gecko64 = fetchurl rec {
      version = "2.47.3";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86_64.msi";
      hash = "sha256-pT7pVDkrbR/j1oVF9uTiqXr7yNyLA6i0QzSVRc4TlnU=";
    };

    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "7.4.0";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      hash = "sha256-ZBP/Mo679+x2icZI/rNUbYEC3thlB50fvwMxsUs6sOw=";
    };

    patches = [
      # Also look for root certificates at $NIX_SSL_CERT_FILE
      ./cert-path.patch
    ];

    updateScript = writeShellScript "update-wine-stable" (''
      ${updateScriptPreamble}
      major=''${UPDATE_NIX_OLD_VERSION%%.*}
      latest_stable=$(get_latest_wine_version "$major.0")

      # Can't use autobump on stable because we don't want the path
      # <source/7.0/wine-7.0.tar.xz> to become <source/7.0.1/wine-7.0.1.tar.xz>.
      if [[ "$UPDATE_NIX_OLD_VERSION" != "$latest_stable" ]]; then
          set_version_and_hash stable "$latest_stable" "$(nix-prefetch-url "$wine_url_base/source/$major.0/wine-$latest_stable.tar.xz")"
      fi

      do_update
    '');
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the hash for staging as well.
    version = "8.17";
    url = "https://dl.winehq.org/wine/source/8.x/wine-${version}.tar.xz";
    hash = "sha256-8BeFvTFix05l3rE6oK3XEeN8SERUcZvt0OjCsaNGm34=";
    inherit (stable) patches;

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.47.4";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86.msi";
      hash = "sha256-Js7MR3BrCRkI9/gUvdsHTGG+uAYzGOnvxaf3iYV3k9Y=";
    };
    gecko64 = fetchurl rec {
      version = "2.47.4";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86_64.msi";
      hash = "sha256-5ZC32YijLWqkzx2Ko6o9M3Zv3Uz0yJwtzCCV7LKNBm8=";
    };

    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "8.0.0";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      hash = "sha256-dbP0XcodyJhX/p6TLaeHEPZMxtSe8asMcjoXcIW0cRs=";
    };

    updateScript = writeShellScript "update-wine-unstable" ''
      ${updateScriptPreamble}
      major=''${UPDATE_NIX_OLD_VERSION%%.*}
      latest_unstable=$(get_latest_wine_version "$major.x")
      latest_gecko=$(get_latest_lib_version wine-gecko)
      latest_mono=$(get_latest_lib_version wine-mono)

      update_staging() {
          staging_url=$(get_source_attr staging.url)
          set_source_attr staging hash "\"$(to_sri "$(nix-prefetch-url --unpack "''${staging_url//$1/$2}")")\""
      }

      autobump unstable "$latest_unstable" "" update_staging
      autobump unstable.gecko32 "$latest_gecko"
      autobump unstable.gecko64 "$latest_gecko"
      autobump unstable.mono "$latest_mono"

      do_update
    '';
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    version = "8.17.1";
    hash = "sha256-h36NDFYsI0y8TG41IH10IdF4QEuBkBewQ3knZ9iwDpg=";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";

    disabledPatchsets = [ ];
  };

  wayland = fetchFromGitLab {
    # https://gitlab.collabora.com/alf/wine/-/tree/wayland
    version = "8.0";
    hash = "sha256-whRnm21UyKZ4AQufNmctzivISVobnCeidmpYz65vlyk=";
    domain = "gitlab.collabora.com";
    owner = "alf";
    repo = "wine";
    rev = "2f80bd757739f2dd8da41abceae6b87d2c568152";

    inherit (unstable) gecko32 gecko64;

    inherit (unstable) mono;

    updateScript = writeShellScript "update-wine-wayland" ''
      ${updateScriptPreamble}
      wayland_rev=$(get_source_attr wayland.rev)

      latest_wayland_rev=$(curl -s 'https://gitlab.collabora.com/api/v4/projects/2847/repository/branches/wayland' | jq -r .commit.id)

      if [[ "$wayland_rev" != "$latest_wayland_rev" ]]; then
          latest_wayland=$(curl -s 'https://gitlab.collabora.com/alf/wine/-/raw/wayland/VERSION' | cut -f3 -d' ')
          wayland_url=$(get_source_attr wayland.url)
          set_version_and_hash wayland "$latest_wayland" "$(nix-prefetch-url --unpack "''${wayland_url/$wayland_rev/$latest_wayland_rev}")"
          set_source_attr wayland rev "\"$latest_wayland_rev\""
      fi

      do_update
    '';
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20230212";
    hash = "sha256-pd37QTcqY5ZaVBssGecuqziOIq1p0JH0ZDB+oLmp9JU=";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;

    updateScript = writeShellScript "update-winetricks" ''
      ${updateScriptPreamble}
      winetricks_repourl=$(get_source_attr winetricks.gitRepoUrl)

      latest_winetricks=$(list-git-tags --url="$winetricks_repourl" | grep -E '^[0-9]{8}$' | sort --reverse --numeric-sort | head -n 1)

      autobump winetricks "$latest_winetricks" 'nix-prefetch-url --unpack'

      do_update
    '';
  };
}
