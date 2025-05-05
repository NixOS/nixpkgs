{
  stdenv,
  callPackage,
  fetchurl,
  lib,
}:

let

  pname = "lens-desktop";
  version = "2024.11.261604";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha256-AbuEU5gOckVU+eDIFnomc7ryLq68ihuk3c0XosoJp74=";
    };
    x86_64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.dmg";
      hash = "sha256-MQQRGTCe+LEHXJi6zjnpENbtlWNP+XVH9rWXRMk+26w=";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha256-aakJCLnQBAnUdrrniTcahS+q3/kP09mlaPTV8FW5afI=";
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
