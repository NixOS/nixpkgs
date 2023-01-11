{ pkgs ? import <nixpkgs> {} }:
## we default to importing <nixpkgs> here, so that you can use
## a simple shell command to insert new sha256's into this file
## e.g. with emacs C-u M-x shell-command
##
##     nix-prefetch-url sources.nix -A {stable{,.mono,.gecko64,.gecko32}, unstable, staging, winetricks}

# here we wrap fetchurl and fetchFromGitHub, in order to be able to pass additional args around it
let fetchurl = args@{url, sha256, ...}:
  pkgs.fetchurl { inherit url sha256; } // args;
    fetchFromGitHub = args@{owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitHub { inherit owner repo rev sha256; } // args;
    fetchFromGitLab = args@{domain, owner, repo, rev, sha256, ...}:
  pkgs.fetchFromGitLab { inherit domain owner repo rev sha256; } // args;

    updateScriptPreamble = ''
      set -eou pipefail
      PATH=${with pkgs; lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep gnused jq nix ]}
      sources_file=${__curPos.file}
      source ${./update-lib.sh}
    '';

    inherit (pkgs) writeShellScript;
in rec {

  stable = fetchurl rec {
    version = "7.0.1";
    url = "https://dl.winehq.org/wine/source/7.0/wine-${version}.tar.xz";
    sha256 = "sha256-gHyqeBIbFiUPJA0oKKB8pOPGCXOeVSTvD0z4muSagWw=";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.47.3";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86.msi";
      sha256 = "sha256-5bmwbTzjVWRqjS5y4ETjfh4MjRhGTrGYWtzRh6f0jgE=";
    };
    gecko64 = fetchurl rec {
      version = "2.47.3";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86_64.msi";
      sha256 = "sha256-pT7pVDkrbR/j1oVF9uTiqXr7yNyLA6i0QzSVRc4TlnU=";
    };

    ## see http://wiki.winehq.org/Mono
    mono = fetchurl rec {
      version = "7.0.0";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      sha256 = "sha256-s35vyeWQ5YIkPcJdcqX8wzDDp5cN/cmKeoHSOEW6iQA=";
    };

    patches = [
      # Also look for root certificates at $NIX_SSL_CERT_FILE
      ./cert-path.patch
    ];

    updateScript = writeShellScript "update-wine-stable" (''
      ${updateScriptPreamble}
      major=''${UPDATE_NIX_OLD_VERSION%.*}
      latest_stable=$(get_latest_wine_version "$major.0")
      latest_gecko=$(get_latest_lib_version wine-gecko)

      # Can't use autobump on stable because we don't want the path
      # <source/7.0/wine-7.0.tar.xz> to become <source/7.0.1/wine-7.0.1.tar.xz>.
      if [[ "$UPDATE_NIX_OLD_VERSION" != "$latest_stable" ]]; then
          set_version_and_sha256 stable "$latest_stable" "$(nix-prefetch-url "$wine_url_base/source/$major.0/wine-$latest_stable.tar.xz")"
      fi

      autobump stable.gecko32 "$latest_gecko"
      autobump stable.gecko64 "$latest_gecko"

      do_update
    '');
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "7.20";
    url = "https://dl.winehq.org/wine/source/7.x/wine-${version}.tar.xz";
    sha256 = "sha256-dRt58itan3LJ7BX3VbALE9PtBz6RaMPvStq9nbN9DVA=";
    inherit (stable) gecko32 gecko64 patches;

    mono = fetchurl rec {
      version = "7.4.0";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      sha256 = "sha256-ZBP/Mo679+x2icZI/rNUbYEC3thlB50fvwMxsUs6sOw=";
    };

    updateScript = writeShellScript "update-wine-unstable" ''
      ${updateScriptPreamble}
      major=''${UPDATE_NIX_OLD_VERSION%.*}
      latest_unstable=$(get_latest_wine_version "$major.x")
      latest_mono=$(get_latest_lib_version wine-mono)

      update_staging() {
          staging_url=$(get_source_attr staging.url)
          set_source_attr staging sha256 "\"$(to_sri "$(nix-prefetch-url --unpack "''${staging_url//$1/$2}")")\""
      }

      autobump unstable "$latest_unstable" "" update_staging
      autobump unstable.mono "$latest_mono"

      do_update
    '';
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    inherit (unstable) version;
    sha256 = "sha256-yzZE06FBoPL65+m8MrKlmW5cSIcX3dZYAOY9wjEJaJw=";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";

    disabledPatchsets = [ ];
  };

  wayland = fetchFromGitLab rec {
    # https://gitlab.collabora.com/alf/wine/-/tree/wayland
    version = "7.20";
    sha256 = "sha256-UrukAnlfrr6eeVwFSEOWSVSfyMHbMT1o1tfXxow61xY=";
    domain = "gitlab.collabora.com";
    owner = "alf";
    repo = "wine";
    rev = "1dc9821ef0b6109c74d0c95cd5418caf7f9feaf1";

    inherit (unstable) gecko32 gecko64;

    inherit (unstable) mono;

    updateScript = writeShellScript "update-wine-wayland" ''
      ${updateScriptPreamble}
      wayland_rev=$(get_source_attr wayland.rev)

      latest_wayland_rev=$(curl -s 'https://gitlab.collabora.com/api/v4/projects/2847/repository/branches/wayland' | jq -r .commit.id)

      if [[ "$wayland_rev" != "$latest_wayland_rev" ]]; then
          latest_wayland=$(curl -s 'https://gitlab.collabora.com/alf/wine/-/raw/wayland/VERSION' | cut -f3 -d' ')
          wayland_url=$(get_source_attr wayland.url)
          set_version_and_sha256 wayland "$latest_wayland" "$(nix-prefetch-url --unpack "''${wayland_url/$wayland_rev/$latest_wayland_rev}")"
          set_source_attr wayland rev "\"$latest_wayland_rev\""
      fi

      do_update
    '';
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20220411";
    sha256 = "sha256-FjH10nZDYbqXI6/vKpZJKfv2maXSVkahNDf5UTU3eyU=";
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
