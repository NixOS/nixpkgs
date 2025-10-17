{
  lib,
  stdenv,
  callPackage,
}:
let
  pname = "aptakube";
  version = "1.13.0";
  meta = {
    homepage = "https://aptakube.com/";
    description = "Modern, lightweight and multi-cluster Kubernetes GUI";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.juliamertz ];
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      meta
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      meta
      ;
  }
