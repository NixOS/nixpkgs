{ stdenv
, callPackage
, channel ? "stable"
, fetchurl
, lib
# This is only relevant for Linux, so we need to pass it through
, polkitPolicyOwners ? [ ] }:

let

  pname = "1password";
  version = if channel == "stable" then "8.10.0" else "8.10.1-19.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        sha256 = "sha256-mIplIW1XGb7EVlPIHgzL16zvVa/3ypfwTMtVSiSvYYE=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        sha256 = "sha256-xjbqZ/+sw3jBzbqhzd/mP7CZOCLYYi6KpX8Ypy/8/Es=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        sha256 = "sha256-06wOSKzxZ7xVAUyIa4Fv48Z6nbMsQ/o74mEyVkmgkJs=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        sha256 = "sha256-zDu3PBj6kvDVpiFuoOuNlmyiSK4ZVuUWX3rBBwlwEvo=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        sha256 = "sha256-F/dnA9mqtXXp5vx6OQ5aPrdeEBMg9g6nozzMMNAZWHk=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        sha256 = "sha256-u8ktPt7W4teCJoXq1eEdKZCEsKxjhep/7DMHSMtuFBA=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        sha256 = "sha256-dZ1Vv4oocDYlw2sibnokUyAKcZ2W7zKofTX2ELamilI=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        sha256 = "sha256-JA2U/PfW2+qHPjqIGQL5gWIdqtd5G1lL3+hecYh2lcE=";
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
