{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    brand = "Behringer";
    type = "X32";
    version = "4.4.1";
    url = "https://cdn.mediavalet.com/aunsw/musictribe/6-vOpP2lRkyNSDXgZEUbQA/FyIw4jc3bk60nseai05MBQ/Original/${type}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-HrSPDWnWF2s1U8Khj6VnLptPdcMVyTivewWAIIdArMc=";
    homepage = "https://www.behringer.com/product.html?modelCode=0603-ACE";
  }
)
