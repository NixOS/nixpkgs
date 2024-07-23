{ stdenv
, callPackage
, channel ? "stable"
, fetchurl
, lib
# This is only relevant for Linux, so we need to pass it through
, polkitPolicyOwners ? [ ] }:

let

  pname = "1password";
  version = if channel == "stable" then "8.10.36" else "8.10.34-10.BETA";

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
        hash = "sha256-eX7D8D5KErFIQtyvg4oT+lR3A7sfRFpDMT7duigZTz0=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-dajdeU8TtD9Dbnp2MFedAl8tuQr275cUqGAnm/VF+OE=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-Dm8v7B8qDSBe1i7OJKQFn7YDPkw3Qj8YVtQkaQmdKuc=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-QSxJoVPlOQU7hbvbuVcB/kf5umRjJQuygMkXq6lE1CQ=";
      };
    };
  };

  src = fetchurl {
    inherit (sources.${channel}.${stdenv.system} or (throw "unsupported system ${stdenv.hostPlatform.system}")) url hash;
  };

  meta = with lib; {
    description = "Multi-platform password manager";
    homepage = "https://1password.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ timstott savannidgerinel sebtm ];
    platforms = builtins.attrNames sources.${channel};
    mainProgram = "1password";
  };

in if stdenv.isDarwin
then callPackage ./darwin.nix { inherit pname version src meta; }
else callPackage ./linux.nix { inherit pname version src meta polkitPolicyOwners; }
