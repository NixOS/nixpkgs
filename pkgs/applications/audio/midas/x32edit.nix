{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  brand = "Behringer";
  type = "X32";
  version = "4.1";
  url = "https://mediadl.musictribe.com/download/software/behringer/${type}/${type}-Edit_LINUX_${version}.tar.gz";
  sha256 = "0zsw7qfmcci87skkpq8vx5zxk35phn8y4byispvki9ascifnnb33";
  homepage = "https://www.behringer.com/behringer/product?modelCode=P0ASF";
})
