{ stdenv
, callPackage
, fetchurl
, lib }:

let

  pname = "lens-desktop";
  version = "2024.3.191333";

  sources = {
    x86_64-linux = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.x86_64.AppImage";
      hash = "sha256-OywOjXzeW/5uyt50JrutiLgem9S1CrlwPFqfK6gUc7U=";
    };
    x86_64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest.dmg";
      hash = "sha256-yf+WBcOdOM3XsfiXJThVws2r84vG2jwfNV1c+sq6A4s=";
    };
    aarch64-darwin = {
      url = "https://api.k8slens.dev/binaries/Lens-${version}-latest-arm64.dmg";
      hash = "sha256-hhd8MnwKWpvG7UebkeEoztS45SJVnpvvJ9Zy+y5swik=";
    };
  };

  src = fetchurl {
    inherit (sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}")) url hash;
  };

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.lens;
    maintainers = with maintainers; [ dbirks RossComputerGuy starkca90 ];
    platforms = builtins.attrNames sources;
  };

in if stdenv.isDarwin then
  callPackage ./darwin.nix { inherit pname version src meta; }
else
  callPackage ./linux.nix { inherit pname version src meta; }
