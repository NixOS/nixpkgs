{
  stdenv,
  callPackage,
  channel ? "stable",
  fetchurl,
  lib,
  # This is only relevant for Linux, so we need to pass it through
  polkitPolicyOwners ? [ ],
}:

let
  pname = "1password";
  version = if channel == "stable" then "8.10.36" else "8.10.38-13.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-yUSU0np6li5zLfFOnebpv0+s1UQ6BdgI+28OvcxS3H8=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-KG0PJ/gwBd9+qYyraRqS/D58Y58VwLd8yCnYzPVWQAY=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-vYhmA9N1izPRo3HPDouOpjJzMwK7LkCHuyYxBGkIPKM=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-v1eCh/cOpA5XcmamAqreKHRQ+waoBQtvvmNO4wvFq6A=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-SeB1Em2WuYvslBv//TROYTAB1asYFhC22IwhcwGi+Qs=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-Ik5gL5FCxNANOKx/MSH7dCz3XEdLr7jxykaWhMQKUVw=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-8cNxhRAOrn/A++APOMUxwrD3+a++ksRMzlmmnQ8J8/c=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-YkZbuCFvWHksLQYKJ3LQD2YDXj9qwHF4Gg8JbxBZsuc=";
      };
    };
  };

  src = fetchurl {
    inherit
      (sources.${channel}.${stdenv.system} or (throw "unsupported system ${stdenv.hostPlatform.system}"))
      url
      hash
      ;
  };

  meta = {
    # Requires to be installed in "/Application" which is not possible for now (https://github.com/NixOS/nixpkgs/issues/254944)
    broken = stdenv.isDarwin;
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      timstott
      savannidgerinel
      sebtm
    ];
    platforms = builtins.attrNames sources.${channel};
    mainProgram = "1password";
  };

in
if stdenv.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      polkitPolicyOwners
      ;
  }
