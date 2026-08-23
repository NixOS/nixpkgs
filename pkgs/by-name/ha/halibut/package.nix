{
  lib,
  stdenv,
  fetchurl,
  cmake,
  perl,
  fetchpatch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "halibut";
  version = "1.3";

  src = fetchurl {
    url = "https://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-${finalAttrs.version}/halibut-${finalAttrs.version}.tar.gz";
    sha256 = "0ciikn878vivs4ayvwvr63nnhpcg12m8023xv514zxqpdxlzg85a";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-charset-cmakelists.patch";
      url = "https://git.tartarus.org/?p=simon/halibut.git;a=blobdiff_plain;f=charset/CMakeLists.txt;h=4613cb4d02959db051dd82b25d6bfd82a50455d7;hp=06eae7703d3e52aa50d5309624ec93a7684f73d8;hb=570407a40bdde2a9bb50c16aa47711202ade8923;hpb=ce14e373b7e6532c0dfa1908fe6030c5667cf79a";
      hash = "sha256-YdLxbXc3C2UxWp0CUzvmJ8mgzqaWJ5Br4VfRU7YjBYE=";
    })
  ];

  nativeBuildInputs = [
    cmake
    perl
  ];

  meta = {
    description = "Documentation production system for software manuals";
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/halibut/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; unix;
    mainProgram = "halibut";
  };
})
