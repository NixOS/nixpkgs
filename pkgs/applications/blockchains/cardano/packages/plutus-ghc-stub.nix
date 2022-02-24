{ mkDerivation, base, bytestring, fetchgit, ghc-boot, lib
, template-haskell
}:
mkDerivation {
  pname = "plutus-ghc-stub";
  version = "8.6.5";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/stubs/plutus-ghc-stub; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    base bytestring ghc-boot template-haskell
  ];
  homepage = "http://www.haskell.org/ghc/";
  description = "The GHC API";
  license = lib.licenses.bsd3;
}
