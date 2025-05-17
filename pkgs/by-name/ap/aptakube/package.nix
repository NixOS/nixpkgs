{
  lib,
  stdenv,
  callPackage,
  ...
}:
let
  pname = "aptakube";
  version = "1.11.5";
  meta = with lib; {
    homepage = "https://aptakube.com/";
    description = "Modern, lightweight and multi-cluster Kubernetes GUI";
    license = licenses.unfree;
    maintainers = with lib.maintainers; [ juliamertz ];
    platforms = platforms.darwin ++ [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
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
