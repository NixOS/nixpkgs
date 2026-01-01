{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    brand = "Behringer";
    type = "X32";
<<<<<<< HEAD
    version = "4.4.1";
    url = "https://cdn.mediavalet.com/aunsw/musictribe/6-vOpP2lRkyNSDXgZEUbQA/FyIw4jc3bk60nseai05MBQ/Original/${type}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-HrSPDWnWF2s1U8Khj6VnLptPdcMVyTivewWAIIdArMc=";
    homepage = "https://www.behringer.com/product.html?modelCode=0603-ACE";
=======
    version = "4.4";
    url = "https://cdn.mediavalet.com/aunsw/musictribe/or9fQ8syH0ShGn-Pei63wQ/POJZwJV4MkWLkgr0ex3f6Q/Original/${type}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-OOh0UnaKes8U2vNkavsCQF9021lFMPLX1gU1ENaWZHs=";
    homepage = "https://www.behringer.com/behringer/product?modelCode=P0ASF";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  }
)
