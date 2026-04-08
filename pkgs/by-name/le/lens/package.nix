{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "lens-desktop";
  version = "2026.3.251250";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha256-8wSJ46njHtC2qhCRNMmVwI/YNs06qoVQn5qkXICACy4=";
    };
    x86_64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.dmg";
      hash = "sha256-Je5+MjhedffRyKFjoh1hJedHXDUASvXZKVd1saLwacc=";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha256-jJRlz4l5hMnk/bDvRuSVVuoe2SMQuZdAZ3RnGaUuvhU=";
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

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      ;
  }
