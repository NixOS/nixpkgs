{ mkDerivation, base, bimap, binary, bytestring, containers, extra
, fetchgit, hedgehog, lib, microlens, microlens-mtl, microlens-th
, mmorph, monad-control, moo, random, template-haskell, temporary
, th-utilities, transformers, tree-diff, typerep-map
}:
mkDerivation {
  pname = "goblins";
  version = "0.2.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/goblins/";
    sha256 = "17c88rbva3iw82yg9srlxjv2ia5wjb9cyqw44hik565f5v9svnyg";
    rev = "cde90a2b27f79187ca8310b6549331e59595e7ba";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base bimap binary bytestring containers extra hedgehog microlens
    microlens-mtl microlens-th mmorph monad-control moo random
    template-haskell th-utilities transformers tree-diff typerep-map
  ];
  testHaskellDepends = [ base hedgehog temporary ];
  homepage = "https://github.com/input-output-hk/goblins";
  description = "Genetic algorithm based randomised testing";
  license = lib.licenses.bsd3;
}
