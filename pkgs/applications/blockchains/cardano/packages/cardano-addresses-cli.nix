{ mkDerivation, aeson, aeson-pretty, ansi-terminal, base, bech32
, bech32-th, bytestring, cardano-address, cardano-addresses
, cardano-crypto, code-page, containers, extra, fetchgit, fmt
, hjsonschema, hpack, hspec, hspec-discover, lib, mtl
, optparse-applicative, process, QuickCheck, safe
, string-interpolate, template-haskell, temporary, text
}:
mkDerivation {
  pname = "cardano-addresses-cli";
  version = "3.7.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-addresses/";
    sha256 = "11dl3fmq7ry5wdmz8kw07ji8yvrxnrsf7pgilw5q9mi4aqyvnaqk";
    rev = "71006f9eb956b0004022e80aadd4ad50d837b621";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/command-line; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal base bech32 bytestring
    cardano-addresses cardano-crypto code-page extra fmt mtl
    optparse-applicative process safe template-haskell text
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base cardano-addresses ];
  testHaskellDepends = [
    aeson base bech32 bech32-th bytestring cardano-addresses containers
    hjsonschema hspec process QuickCheck string-interpolate temporary
    text
  ];
  testToolDepends = [ cardano-address hspec-discover ];
  prePatch = "hpack";
  homepage = "https://github.com/input-output-hk/cardano-addresses#readme";
  description = "Utils for constructing a command-line on top of cardano-addresses";
  license = lib.licenses.asl20;
}
