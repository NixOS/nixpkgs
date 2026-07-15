{
  stdenv,
  fetchurl,
  lib,
  callPackage,
  qt6Packages,
}:

let
  # Upstream replaces minor versions, so use archived URLs.
  srcs = rec {
    x86_64-linux = fetchurl {
      url = "https://web.archive.org/web/20260414052921/https://filehost.perforce.com/perforce/r26.1/bin.linux26x86_64/p4v.tgz";
      sha256 = "sha256-89Xz9dxAeLGOOr90K0CdlxjrfIf9vUmyZV3tzWspWdQ=";
    };
    aarch64-darwin = fetchurl {
      url = "https://web.archive.org/web/20260414052748/https://filehost.perforce.com/perforce/r26.1/bin.macosx12u/P4V.dmg";
      sha256 = "sha256-8MBLS6EQOVenxZ1Uv75kPzU8aO2AldmxkwOz+JcBRpY=";
    };
    # this is universal
    x86_64-darwin = aarch64-darwin;
  };

  mkDerivation =
    if stdenv.hostPlatform.isDarwin then
      callPackage ./darwin.nix { }
    else
      qt6Packages.callPackage ./linux.nix { };
in
mkDerivation {
  pname = "p4v";
  version = "2026.1/2933292";

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    description = "Perforce Helix Visual Client";
    homepage = "https://www.perforce.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = builtins.attrNames srcs;
    maintainers = with lib.maintainers; [
      impl
      nathyong
      nioncode
    ];
  };
}
