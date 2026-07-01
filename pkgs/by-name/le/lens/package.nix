{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "lens-desktop";
  version = "2026.6.260931";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha512-P9PrtbGKaHNlzZsm10ovkYCBBfQpVWBgcVsYLETMwINP2bzrIIK5HVbkbcTEUsxK90L7MQmFwpAssojW0b9G5Q==";
    };
    x86_64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.dmg";
      hash = "sha512-I/i9s7O3jT+eNqqUu6B+rB+YbegKhAsZwHlc3mp2wNWW9YDilQbzKrhF9Fq2dSz2WKVZUscBtSGtXCuiPcFXzw==";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha512-eCE3w7NlYrHiexCirH2wFN0nOO3qAt5acbldXbDMVIrG94tbgM8Y5ZO8/YIUN45XbotYtKW8/Nw+WsrTp6DPBg==";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  meta = {
    description = "Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = lib.licenses.lens;
    maintainers = with lib.maintainers; [
      dbirks
      RossComputerGuy
      starkca90
    ];
    platforms = builtins.attrNames sources;
  };

  updateScript = ./update.sh;

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      updateScript
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      updateScript
      ;
  }
