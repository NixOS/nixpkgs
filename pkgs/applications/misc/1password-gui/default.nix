{ stdenv
, callPackage
, channel ? "stable"
, fetchurl
, lib
# This is only relevant for Linux, so we need to pass it through
, polkitPolicyOwners ? [ ] }:

let

  pname = "1password";
  version = if channel == "stable" then "8.10.27" else "8.10.28-21.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-xQQXPDC8mvQyC+z3y0n5KpRpLjrBeslwXPf28wfKVSM=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-c26G/Zp+1Y6ZzGYeybFBJOB2gDx3k+4/Uu7sMlXHYjM=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-9LrSJ9PLRXFbA7xkBbqFIZVtAuy7UrDBh7e6rlLqrM0=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-4oqpsRZ10y2uh2gp4QyHfUdKER8v8n8mjNFVwKRYkpo=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-Pz9tpGsKLmf37r0fnBxcE7qGjN3RZSF/iwQUnqev0Jk=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-ezzdwUUcSBqJUKlG1By5HXbgrTFDpaGIJipU+V1FUBc=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-zFO8ypDqPGcJY/2eKke/ljQ4S3syI7jyZSexbYzBA+c=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-LAhGmXqfcgjiDbE0RLhzpi15rluM8/fZ3GZ52yHdMKg=";
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
