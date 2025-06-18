{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    brand = "Midas";
    type = "M32";
    version = "4.3";
    url = "https://mediadl.musictribe.com/download/software/midas_${type}/${type}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-1+7xGmSqIPn5NGOnk2VvPJxkI2y1em/kjeldXU0M35w=";
    homepage = "https://midasconsoles.com/midas/product?modelCode=P0B3I";
  }
)
