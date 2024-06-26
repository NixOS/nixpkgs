{ stdenv
, fetchurl
, lib
, callPackage
}:

let
  # Upstream replaces minor versions, so use archived URLs.
  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://web.archive.org/web/20231108005633id_/https://ftp.perforce.com/perforce/r23.3/bin.linux26x86_64/p4v.tgz";
      sha256 = "18b275c2d96fb90cc94bb55b132e69f85fb2f4f3f34794d0c5ef7ed63271402a";
    };
    "x86_64-darwin" = fetchurl {
      url = "https://web.archive.org/web/20231108010205id_/https://ftp.perforce.com/perforce/r23.3/bin.macosx12u/P4V.dmg";
      sha256 = "2f846b6a2db71f44292f2137c4289f1294ab0c4ba55ab2f2495befd78b6a85c0";
    };
    "aarch64-darwin" = fetchurl {
      url = "https://web.archive.org/web/20231108010205id_/https://ftp.perforce.com/perforce/r23.3/bin.macosx12u/P4V.dmg";
      sha256 = "2f846b6a2db71f44292f2137c4289f1294ab0c4ba55ab2f2495befd78b6a85c0";
    };
  };

  mkDerivation =
    if stdenv.isDarwin then callPackage ./darwin.nix { }
    else callPackage ./linux.nix { };
in
mkDerivation {
  pname = "p4v";
  version = "2023.3.2495381";

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
