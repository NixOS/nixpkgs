{ stdenv
, fetchurl
, lib
, callPackage
, libsForQt5
}:

let
  # Upstream replaces minor versions, so use archived URLs.
  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://web.archive.org/web/20220902181457id_/https://ftp.perforce.com/perforce/r22.2/bin.linux26x86_64/p4v.tgz";
      sha256 = "8fdade4aafe25f568a61cfd80823aa90599c2a404b7c6b4a0862c84b07a9f8d2";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://web.archive.org/web/20220902194716id_/https://ftp.perforce.com/perforce/r22.2/bin.macosx1015x86_64/P4V.dmg";
      sha256 = "c4a9460c0f849be193c68496c500f8a785c740f5bea5b5e7f617969c20be3cd7";
    };
  };

  mkDerivation =
    if stdenv.isDarwin then callPackage ./darwin.nix { }
    else libsForQt5.callPackage ./linux.nix { };
in mkDerivation {
  pname = "p4v";
  version = "2022.2.2336701";

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
