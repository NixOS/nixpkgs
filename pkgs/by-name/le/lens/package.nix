{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "lens-desktop";
  version = "2026.10.261408";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha512-I24wkF3qxHbiYJ1nJEAT4jBVyKVTMKFrwOErLFXOyz++CVDC6L399n1gSAZaGPB43vzviQzrILD8UojTAl2ZMA==";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha512-2G0thB91JpSQGtpGXxL9N9vMYWWxfaVFTWiOMtnuQnMOjS+xq7kmoPOLB3FZDAWxvUNBWXnOdKW7NCvMJ9+ZwA==";
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
