{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "lens-desktop";
  version = "2026.8.270956";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha512-0mYzoQPGo0x6JT0iB+wPPa9ia8TsP4V6Mfa0NEJLz+uZWXD3rDqHJQSOxbDkKQ/nQSrSZQ7a2Qx1Np1Jea1S2Q==";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha512-PO0ntwaiy+hGMJESfAsRQZw5Bgbe66P6JBAg28FQMqbxSaNoEhGKboDY8+OGIbkJ1GLR23gsB0qPBlPpgYsVGQ==";
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
