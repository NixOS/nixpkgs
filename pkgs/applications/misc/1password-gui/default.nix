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
  version = if channel == "stable" then "8.10.60" else "8.10.60-4.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-QCoV66LvGo6vA5fjuE3fG+LwehKVMPmgaDghh9YEvmA=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-E5TniXur9ATJ3ER/zTFc6EiBrH/kbNvIao0ADLyBZZE=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-2Nv4CHKLgCFbU1TeJQhIq8YdkJSQJXtUw2S17B8cS4s=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-drJiM8EiUM3M54+KPQdLvAmSfBH5YPqQk14yjHzoBtM=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-c9r/t7VpClf2RQfLLyKdpU90RYlPEPA4N2PjrL2QXAo=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-Tf19dRmf7wufUJQf9m/M2Nwrs4yGW/idzs8FsgkM96o=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-lOQjuXLCCBF1lmEwkLrfX8Pjlwwx5wAa5WBDdf60VnQ=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-2wYmLIxvUDlqKrCsSmI/yCoNOrMEgPdfrHJHMwFYkyo=";
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
    broken = stdenv.hostPlatform.isDarwin;
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      khaneliman
      timstott
      savannidgerinel
      sebtm
    ];
    platforms = builtins.attrNames sources.${channel};
    mainProgram = "1password";
  };

in
if stdenv.hostPlatform.isDarwin then
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
