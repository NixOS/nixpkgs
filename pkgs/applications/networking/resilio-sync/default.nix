{ lib, stdenv, callPackage, fetchurl, libxcrypt, ... }:
let
  pname = "resilio-sync";
  version = "2.7.3";

  sources = rec {
    x86_64-linux = {
      url = "https://download-cdn.resilio.com/${version}/linux-x64/resilio-sync_x64.tar.gz";
      sha256 = "sha256-DYQs9KofHkvtlsRQHRLwQHoHwSZkr40Ih0RVAw2xv3M=";
    };

    i686-linux = {
      url = "https://download-cdn.resilio.com/${version}/linux-i386/resilio-sync_i386.tar.gz";
      sha256 = "sha256-PFKVBs0KthG4tuvooHkAciPhNQP0K8oi2LyoRUs5V7I=";
    };

    aarch64-linux = {
      url = "https://download-cdn.resilio.com/${version}/linux-arm64/resilio-sync_arm64.tar.gz";
      sha256 = "sha256-o2DlYOBTkFhQMEDJySlVSNlVqLNbBzacyv2oTwxrXto=";
    };

    x86_64-darwin = {
      url = "https://download-cdn.resilio.com/${version}/osx/Resilio-Sync.dmg";
      sha256 = "sha256-pRFP8Eyk86ggeYAsFoPBQYiArAoGinQ4hcozs0kpbWo=";
    };
    aarch64-darwin = x86_64-darwin;
  };

  src = fetchurl {
    inherit (sources.${stdenv.system}) url sha256;
  };

  meta = with lib; {
    description = "Automatically sync files via secure, distributed technology";
    homepage = "https://www.resilio.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = builtins.attrNames sources;
    maintainers = with maintainers; [ domenkozar thoughtpolice cwoac jwoudenberg berryp ];
  };

in
if stdenv.isDarwin
then callPackage ./darwin.nix { inherit pname version src meta; }
else callPackage ./linux.nix { inherit pname version src meta; }
