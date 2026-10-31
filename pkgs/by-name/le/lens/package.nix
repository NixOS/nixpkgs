{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "lens-desktop";
  version = "2026.10.121159";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha512-gfyeMP0Zzum+XvvmRpE3SLCp4LJp65YmTdSJRauY9g8aWG7R/3LGH/3a1CmfEgz86GksZzADIY6EuQZctzG9Yw==";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha512-ZO0CX1QVQ9jtLQtFbQ6qU8fa+eLSCUdWDgK3B8cqr2R5a9QeczJ0Cm/rc5a3RFbkd1EVdAXw/6gP6aN68+xWoA==";
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
      qweered
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
