{ stdenv
, fetchurl
, lib
, callPackage
, qt6Packages
}:

let
  version = "2024.3.2656785";

  # Upstream replaces minor versions, so use archived URLs.
  srcs = rec {
    x86_64-linux = fetchurl {
      url = "https://github.com/impl/nix-p4-archive/releases/download/p4v-${version}/p4v-${version}-linux26x86_64.tgz";
      hash = "sha256-Jmj14DMP9tyo+QPyyWTNdEjAcYT06mkIvM+FrJgVIz4=";
    };
    aarch64-darwin = fetchurl {
      url = "https://github.com/impl/nix-p4-archive/releases/download/p4v-${version}/p4v-${version}-macosx12u.dmg";
      hash = "sha256-bQw6Lu/MQKWkfBwe6ZHu0O+JEbVM+2UjRXLs4njHGe0=";
    };
    # this is universal
    x86_64-darwin = aarch64-darwin;
  };

  mkDerivation =
    if stdenv.hostPlatform.isDarwin then callPackage ./darwin.nix { }
    else qt6Packages.callPackage ./linux.nix { };
in mkDerivation {
  pname = "p4v";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    description = "Perforce Helix Visual Client";
    homepage = "https://www.perforce.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = builtins.attrNames srcs;
    maintainers = with lib.maintainers; [ impl nathyong nioncode ];
  };
}
