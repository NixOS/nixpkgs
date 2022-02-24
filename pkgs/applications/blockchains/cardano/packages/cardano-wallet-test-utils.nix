{ mkDerivation, aeson, base, containers, contra-tracer, directory
, either, extra, fetchgit, file-embed, filepath, fmt, formatting
, generic-lens, generics-sop, hspec, hspec-core, hspec-discover
, hspec-expectations, hspec-expectations-lifted, hspec-golden-aeson
, http-api-data, HUnit, int-cast, iohk-monitoring, lattices, lib
, optparse-applicative, pretty-simple, QuickCheck
, quickcheck-classes, say, silently, template-haskell, text
, text-class, time, unliftio, unliftio-core, wai-app-static, warp
}:
mkDerivation {
  pname = "cardano-wallet-test-utils";
  version = "2022.1.18";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/test-utils; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base containers contra-tracer directory either file-embed
    filepath fmt formatting generics-sop hspec hspec-core
    hspec-expectations hspec-golden-aeson http-api-data HUnit int-cast
    iohk-monitoring lattices optparse-applicative pretty-simple
    QuickCheck quickcheck-classes say template-haskell text text-class
    time unliftio unliftio-core wai-app-static warp
  ];
  testHaskellDepends = [
    base containers extra fmt generic-lens generics-sop hspec
    hspec-core hspec-expectations-lifted lattices QuickCheck silently
    unliftio unliftio-core
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Shared utilities for writing unit and property tests";
  license = lib.licenses.asl20;
}
