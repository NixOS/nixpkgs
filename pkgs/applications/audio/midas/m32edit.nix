{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  brand = "Midas";
  type = "M32";
  version = "4.1";
  url = "https://mediadl.musictribe.com/download/software/midas_${type}/${type}-Edit_LINUX_${version}.tar.gz";
  sha256 = "0aqhdrxqa49liyvbbw5x32kwk0h1spzvmizmdxklrfs64vvr9bvh";
  homepage = "https://midasconsoles.com/midas/product?modelCode=P0B3I";
})
