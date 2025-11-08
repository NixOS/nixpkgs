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
      url = "https://web.archive.org/web/20240612193642id_/https://ftp.perforce.com/perforce/r24.2/bin.linux26x86_64/p4v.tgz";
      sha256 = "sha256-HA99fHcmgli/vVnr0M8ZJEsaZ2ZLzpG3M8S77oDYJyE=";
    };
    aarch64-darwin = fetchurl {
      url = "https://web.archive.org/web/20240612194532id_/https://ftp.perforce.com/perforce/r24.2/bin.macosx12u/P4V.dmg";
      sha256 = "sha256-PS7gfDdWspyL//YWLkrsGi5wh6SIeAry2yef1/V0d6o=";
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
  version = "2024.2/2606884";

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
