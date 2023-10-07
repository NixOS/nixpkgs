{ stdenv
, callPackage
, channel ? "stable"
, fetchurl
, lib
# This is only relevant for Linux, so we need to pass it through
, polkitPolicyOwners ? [ ] }:

let

  pname = "1password";
  version = if channel == "stable" then "8.10.16" else "8.10.18-19.BETA";

  sources = {
    stable = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-p9JTJUwPqJAAykhfVwlEkPlqgZ0h9VLQR3K2BYABn5I=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/stable/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-RyG1QzmErwJi31pytlOjWE6QfhWjvZQuaTEtIEpg02k=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-a2U6jmHMZY4PgigLCzTAOOtt5xOSV6sqJy7Tr2y2VvQ=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-0LKAiY+eLYeWG/66d7n92aqI2nHZMijS0YM/d9TqYFo=";
      };
    };
    beta = {
      x86_64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/x86_64/1password-${version}.x64.tar.gz";
        hash = "sha256-siQ6w1byDkfNrbkvjLWmQRbJ5nVZZv24vg0RFWaRHmE=";
      };
      aarch64-linux = {
        url = "https://downloads.1password.com/linux/tar/beta/aarch64/1password-${version}.arm64.tar.gz";
        hash = "sha256-WX6NzBXBSBf/hIl1kTIuUvCnEZ1+B0NBHfKvMeIZOw4=";
      };
      x86_64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-x86_64.zip";
        hash = "sha256-HQRw1OGIT/cVjDk4PGa8x4QdYHQxtqMePsUh+cpyysM=";
      };
      aarch64-darwin = {
        url = "https://downloads.1password.com/mac/1Password-${version}-aarch64.zip";
        hash = "sha256-1KcTgmxDhbvB6gzTqF3bhu5toCSjskGjCflrBSNYzk4=";
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
