{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  brand = "Behringer";
  type = "X-AIR";
  version = "1.8.1";
  url = "https://mediadl.musictribe.com/download/software/behringer/XAIR/${version}/X-AIR-Edit_LINUX_${version}.tar.gz";
  sha256 = "sha256-vFy3/iAsGs1IlBSYAX5zTghbPtBfFCUtqVFxfMsFCGY=";
  homepage = "https://www.behringer.com/product.html?modelCode=0605-AAD";
})
