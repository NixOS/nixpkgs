{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "lens-desktop";
  version = "2026.10.51501";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha512-NSCV9zkwhhpy3P1QB//OqFmZO7cfIMotosSwQyKacQUrOo6hcjPKetbXN1Nr5rIPdbeKdQGphArO5T/vY7NaCg==";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha512-Rl+rlJXUlgo84MWxBj6p4J/6se/5z9elU+g4iszAqgeJAqb5Onm7ASHUoCqSYdCJLFuttt7gBiVpOWqROCbW5w==";
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
