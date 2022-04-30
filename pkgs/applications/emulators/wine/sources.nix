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
in rec {

  stable = fetchurl rec {
    version = "7.0";
    url = "https://dl.winehq.org/wine/source/7.0/wine-${version}.tar.xz";
    sha256 = "sha256-W0PifVwIXLGPlzlORhgDENXu98HZHGiVQyo4ibLeCGs=";

    ## see http://wiki.winehq.org/Gecko
    gecko32 = fetchurl rec {
      version = "2.47.2";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86.msi";
      sha256 = "07d6nrk2g0614kvwdjym1wq21d2bwy3pscwikk80qhnd6rrww875";
    };
    gecko64 = fetchurl rec {
      version = "2.47.2";
      url = "https://dl.winehq.org/wine/wine-gecko/${version}/wine-gecko-${version}-x86_64.msi";
      sha256 = "0iffhvdawc499nbn4k99k33cr7g8sdfcvq8k3z1g6gw24h87d5h5";
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
  };

  unstable = fetchurl rec {
    # NOTE: Don't forget to change the SHA256 for staging as well.
    version = "7.4";
    url = "https://dl.winehq.org/wine/source/7.x/wine-${version}.tar.xz";
    sha256 = "sha256-co6GbW5JzpKioMUUMz6f8Ivb9shvXvTmGAFDuNK31BY=";
    inherit (stable) gecko32 gecko64 patches;

    mono = fetchurl rec {
      version = "7.1.1";
      url = "https://dl.winehq.org/wine/wine-mono/${version}/wine-mono-${version}-x86.msi";
      sha256 = "sha256-ncjlYDt7xkNU65SuTqD2ghQkdno/9E/w0Z40akkMEeo=";
    };
  };

  staging = fetchFromGitHub rec {
    # https://github.com/wine-staging/wine-staging/releases
    inherit (unstable) version;
    sha256 = "0vlj3b8bnidyhlgkjrnlbah3878zjy3s557vbp16qka42zjaa51q";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";

    disabledPatchsets = [ ];
  };

  wayland = fetchFromGitLab rec {
    version = "7.0-rc2";
    sha256 = "sha256-FU9L8cyIIfFQ+8f/AUg7IT+RxTpyNTuSfL0zBnur0SA=";
    domain = "gitlab.collabora.com";
    owner = "alf";
    repo = "wine";
    rev = "95f0154c96a4b7d81e783ee5ba2f5d9cc7cda351";

    inherit (unstable) gecko32 gecko64;

    inherit (unstable) mono;
  };

  winetricks = fetchFromGitHub rec {
    # https://github.com/Winetricks/winetricks/releases
    version = "20210825";
    sha256 = "sha256-exMhj3dS8uXCEgOaWbftaq94mBOmtZIXsXb9xNX5ha8=";
    owner = "Winetricks";
    repo = "winetricks";
    rev = version;
  };
}
