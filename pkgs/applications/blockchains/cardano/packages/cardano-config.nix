{ mkDerivation, base, cardano-prelude, fetchgit, file-embed, lib
, process, template-haskell, text
}:
mkDerivation {
  pname = "cardano-config";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-config/";
    sha256 = "1wm1c99r5zvz22pdl8nhkp13falvqmj8dgkm8fxskwa9ydqz01ld";
    rev = "e9de7a2cf70796f6ff26eac9f9540184ded0e4e6";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    base cardano-prelude file-embed process template-haskell text
  ];
  license = lib.licenses.asl20;
}
