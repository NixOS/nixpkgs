{ stdenv
, callPackage
, channel ? "stable"
, fetchurl
, lib
# This is only relevant for Linux, so we need to pass it through
, polkitPolicyOwners ? [ ] }:

let

  pname = "1password";
  version = if channel == "stable" then "8.10.6" else "8.10.6-20.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        sha256 = "sha256-wCY94x67z+X8l3wr79+BXuu6/UXJldbVIA67AAD9mj0=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        sha256 = "sha256-iLjuudWmkLMuoZSZZo9pRpx0MZludUrGTpTHCTNk4Vo=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        sha256 = "sha256-FVj5x1RVBxPsgWhG6R4ykarZdLdJcj6gO5mQy3hHB4M=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        sha256 = "sha256-ilQP1OF4gydzlLZq3aZzqNbzvacRbruzWS7pVt6DP9g=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        sha256 = "sha256-zhZF6BlJMlEcjKUv43f5yKv8cOzjX01yiVtIrAgw578=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        sha256 = "sha256-pzZSV4mKhdm/zGErWSLwaf0WISvYBheGzCgB34ysCe4=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        sha256 = "sha256-2Lbh5WPhBAJxvZ7J8/DDXDHkN8Th595RdA/S4Dwi3+0=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        sha256 = "sha256-XpVT5yfo6HkvbmZWyoPLD7/M3FrNIKec6yt450bPUxQ=";
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
