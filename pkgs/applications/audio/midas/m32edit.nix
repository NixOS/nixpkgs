{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    brand = "Midas";
    type = "M32";
<<<<<<< HEAD
    version = "4.4.1";
    url = "https://cdn.mediavalet.com/aunsw/musictribe/Yd1JkAyxqUeqIxoRM0lWWw/uwBe453FiEKSpqZzdjvYpQ/Original/${type}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-cEva2Brxo7zm3qppO+BtYIlUqV9t69j+8f6g94C4i3c=";
    homepage = "https://www.midasconsoles.com/series.html?category=R-MIDAS-M32SERIES";
=======
    version = "4.4";
    url = "https://cdn.mediavalet.com/aunsw/musictribe/bpXmqFLKmkCfv8Xfp2fzGA/p_73LRnDKUyTLCRF8SiAhg/Original/${type}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-/rzTIRYP982upiyPlg1B5L+ggSFb5jfmGKAQGhKghaA=";
    homepage = "https://midasconsoles.com/midas/product?modelCode=P0B3I";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  }
)
