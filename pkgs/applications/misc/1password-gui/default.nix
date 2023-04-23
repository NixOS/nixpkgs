{ stdenv
, callPackage
, channel ? "stable"
, fetchurl
, lib
# This is only relevant for Linux, so we need to pass it through
, polkitPolicyOwners ? [ ] }:

let

  pname = "1password";
  version = if channel == "stable" then "8.10.4" else "8.10.5-10.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        sha256 = "sha256-zFB8bUl0FNmMvNN5AoDeYdUjasJblVxRAi50V2BF5OU=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        sha256 = "sha256-gALQ43mAJy3eX/0qmdBp0yfMLgAdqAqD93CbDydvJR8=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        sha256 = "sha256-4kpf3U4G3Jx8g24kU4nXZbDA3o29hEpwACOE2zAadhA=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        sha256 = "sha256-eTRI7reSZ24S8uwNFPk8BkwMexdoXD5tlL6Bd3zzIGI=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        sha256 = "sha256-GM93nW7kGeC2Mmq1ZtOK72RQc0QHvlWedDLEAmqtPt4=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        sha256 = "sha256-f0K35utZ/WPv08wRe/ZQPWC/IYiXsf/tBqhKjgeNBHc=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        sha256 = "sha256-zWS1nmRNm2SjMKWRbCJp4DRCzvVsdATdf/EMlpvRz1k=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        sha256 = "sha256-fQ98NJI5h0IBvrcsV8GBt9RBWDiyYq0NPtS5B5ikz8k=";
      };
    };
  };

  src = fetchurl {
    inherit (sources.${channel}.${stdenv.system}) url sha256;
  };

  meta = with lib; {
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ timstott savannidgerinel maxeaubrey sebtm ];
    platforms = builtins.attrNames sources.${channel};
  };

in if stdenv.isDarwin
then callPackage ./darwin.nix { inherit pname version src meta; }
else callPackage ./linux.nix { inherit pname version src meta polkitPolicyOwners; }
