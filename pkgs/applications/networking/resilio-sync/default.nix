{ lib, stdenv, fetchurl, ... }:

stdenv.mkDerivation rec {
  pname = "resilio-sync";
  version = "2.7.3";

  src = {
    x86_64-linux = fetchurl {
      url = "https://download-cdn.resilio.com/${version}/linux-x64/resilio-sync_x64.tar.gz";
      sha256 = "sha256-DYQs9KofHkvtlsRQHRLwQHoHwSZkr40Ih0RVAw2xv3M=";
    };

    i686-linux = fetchurl {
      url = "https://download-cdn.resilio.com/${version}/linux-i386/resilio-sync_i386.tar.gz";
      sha256 = "sha256-PFKVBs0KthG4tuvooHkAciPhNQP0K8oi2LyoRUs5V7I=";
    };

    aarch64-linux = fetchurl {
      url = "https://download-cdn.resilio.com/${version}/linux-arm64/resilio-sync_arm64.tar.gz";
      sha256 = "sha256-o2DlYOBTkFhQMEDJySlVSNlVqLNbBzacyv2oTwxrXto=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontStrip = true; # Don't strip, otherwise patching the rpaths breaks
  sourceRoot = ".";

  installPhase = ''
    install -D rslsync "$out/bin/rslsync"
    patchelf \
      --interpreter "$(< $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${lib.makeLibraryPath [ stdenv.cc.libc ]} "$out/bin/rslsync"
  '';

  meta = with lib; {
    description = "Automatically sync files via secure, distributed technology";
    homepage    = "https://www.resilio.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license     = licenses.unfreeRedistributable;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ domenkozar thoughtpolice cwoac ];
  };
}
