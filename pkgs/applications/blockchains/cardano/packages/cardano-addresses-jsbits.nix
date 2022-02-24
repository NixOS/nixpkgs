{ mkDerivation, base, fetchgit, hpack, lib }:
mkDerivation {
  pname = "cardano-addresses-jsbits";
  version = "3.7.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-addresses/";
    sha256 = "11dl3fmq7ry5wdmz8kw07ji8yvrxnrsf7pgilw5q9mi4aqyvnaqk";
    rev = "71006f9eb956b0004022e80aadd4ad50d837b621";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/jsbits; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [ base ];
  libraryToolDepends = [ hpack ];
  prePatch = "hpack";
  homepage = "https://github.com/input-output-hk/cardano-addresses#readme";
  description = "Javascript code for ghcjs build of cardano-addresses";
  license = lib.licenses.asl20;
}
