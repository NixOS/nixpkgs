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
    version = "10.0";
    url = "https://dl.winehq.org/wine/source/10.0/wine-${version}.tar.xz";
    hash = "sha256-xeCz9ffvr7MOnNTZxiS4XFgxcdM1SdkzzTQC80GsNgE=";

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
      version = "8.1.0";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      hash = "sha256-DtPsUzrvebLzEhVZMc97EIAAmsDFtMK8/rZ4rJSOCBA=";
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
    version = "10.2";
    url = "https://dl.winehq.org/wine/source/10.x/wine-${version}.tar.xz";
    hash = "sha256-nZDfts8QuBCntHifAGdxK0cw0+oqiLkfG+Jzsq0EJD8=";
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
      version = "9.4.0";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      hash = "sha256-z2FzrpS3np3hPZp0zbJWCohvw9Jx+Uiayxz9vZYcrLI=";
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

  staging = fetchFromGitLab rec {
    # https://gitlab.winehq.org/wine/wine-staging
    inherit (unstable) version;
    hash = "sha256-qWje1nJ5LIVFj5PmB6RRITYOWGovXzCLEVFTazmp30o=";
    domain = "gitlab.winehq.org";
    owner = "wine";
    repo = "wine-staging";
    rev = "v${version}";

    disabledPatchsets = [ ];
  };

  wayland = pkgs.lib.warnOnInstantiate "building wine with `wineRelease = \"wayland\"` is deprecated. Wine now builds with the wayland driver by default." stable; # added 2025-01-23

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20250102";
    hash = "sha256-Km2vVTYsLs091cjmNTW8Kqku3vdsEA0imTtZfqZWDQo=";
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
