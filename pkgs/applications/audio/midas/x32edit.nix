{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    brand = "Behringer";
    type = "X32";
    version = "4.3";
    url = "https://mediadl.musictribe.com/download/software/behringer/${type}/${type}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-iVBBW6qVtEGlNXqKRZxObB9WfbOEjXMA1Nsp1CTFOH4=";
    homepage = "https://www.behringer.com/behringer/product?modelCode=P0ASF";
  }
)
