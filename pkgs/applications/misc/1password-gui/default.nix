{ stdenv
, callPackage
, channel ? "stable"
, fetchurl
, lib
# This is only relevant for Linux, so we need to pass it through
, polkitPolicyOwners ? [ ] }:

let

  pname = "1password";
  version = if channel == "stable" then "8.10.28" else "8.10.30-11.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-1EfP8z+vH0yRklkcxCOPYExu13iFcs6jOdvWBzl64BA=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-E4MfpHVIn5Vu/TcDgwkoHdSnKthaAMFJZArnmSH5cxA=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-+cXirJyDnxfE5FN8HEIrEyyoGvVrJ+0ykBHON9oHAek=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-zKAgAKYIgy5gZbe2IpskV8DG8AKtamYqq8cF/mTpRss=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-6zyDZRsk9FZXJuGqqt1kCATcL99PjYP/wQzqE/4e4kg=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-JwHk6Byqd5LxVWBT/blRVnYhgSeYfaVY3Ax4GkLcFxM=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-h7vJguOEQBEvX9Z9MjdLj0hPnn8hJpeWRoduVowznLg=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-g6lorMdQ56B6gd4YN4WQSkztwHqIgO7QshM1zocpqTE=";
      };
    };
  };

  src = fetchurl {
    inherit (sources.${channel}.${stdenv.system}) url hash;
  };

  meta = with lib; {
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ timstott savannidgerinel amaxine sebtm ];
    platforms = builtins.attrNames sources.${channel};
    mainProgram = "1password";
  };

in if stdenv.isDarwin
then callPackage ./darwin.nix { inherit pname version src meta; }
else callPackage ./linux.nix { inherit pname version src meta polkitPolicyOwners; }
