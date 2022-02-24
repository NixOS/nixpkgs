{ mkDerivation, aeson, aeson-pretty, base, base58-bytestring
, basement, bech32, bech32-th, binary, bytestring, cardano-crypto
, cborg, containers, cryptonite, deepseq, digest, either
, exceptions, extra, fetchgit, fmt, hashable, hpack, hspec
, hspec-discover, hspec-golden, lib, memory, pretty-simple
, QuickCheck, text, unordered-containers
}:
mkDerivation {
  pname = "cardano-addresses";
  version = "3.7.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-addresses/";
    sha256 = "11dl3fmq7ry5wdmz8kw07ji8yvrxnrsf7pgilw5q9mi4aqyvnaqk";
    rev = "71006f9eb956b0004022e80aadd4ad50d837b621";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/core; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base base58-bytestring basement bech32 bech32-th binary
    bytestring cardano-crypto cborg containers cryptonite deepseq
    digest either exceptions extra fmt hashable memory text
    unordered-containers
  ];
  libraryToolDepends = [ hpack ];
  testHaskellDepends = [
    aeson aeson-pretty base bech32 binary bytestring cardano-crypto
    containers hspec hspec-golden memory pretty-simple QuickCheck text
  ];
  testToolDepends = [ hspec-discover ];
  prePatch = "hpack";
  homepage = "https://github.com/input-output-hk/cardano-addresses#readme";
  description = "Library utilities for mnemonic generation and address derivation";
  license = lib.licenses.asl20;
}
