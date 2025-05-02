{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "lens-desktop";
  version = "2025.9.151055";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha256-XIEAhda75yseNmGSbHwOSqkzSSWCHUiyZm1rf+eEqs0=";
    };
    x86_64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.dmg";
      hash = "sha256-ORwUdpyLDvPCcC8v3HeFt3f2I+qNSIi9UgERrvgH2AE=";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha256-cu9TUTk3TJgdotJDUVielIDIGTocCIPVQiwJHEKeiIA=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  meta = with lib; {
    description = "Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.lens;
    maintainers = with maintainers; [
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
