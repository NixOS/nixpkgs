{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    brand = "Midas";
    type = "M32";
    version = "4.4";
    url = "https://cdn.mediavalet.com/aunsw/musictribe/bpXmqFLKmkCfv8Xfp2fzGA/p_73LRnDKUyTLCRF8SiAhg/Original/${type}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-/rzTIRYP982upiyPlg1B5L+ggSFb5jfmGKAQGhKghaA=";
    homepage = "https://midasconsoles.com/midas/product?modelCode=P0B3I";
  }
)
