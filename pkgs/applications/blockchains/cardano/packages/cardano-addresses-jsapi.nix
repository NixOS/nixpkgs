{ mkDerivation, aeson, aeson-pretty, base, bytestring
, cardano-addresses, cardano-addresses-cli, exceptions, fetchgit
, jsaddle, jsaddle-warp, lens, lib, mtl, text
}:
mkDerivation {
  pname = "cardano-addresses-jsapi";
  version = "3.7.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-addresses/";
    sha256 = "11dl3fmq7ry5wdmz8kw07ji8yvrxnrsf7pgilw5q9mi4aqyvnaqk";
    rev = "71006f9eb956b0004022e80aadd4ad50d837b621";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/jsapi; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty base bytestring cardano-addresses
    cardano-addresses-cli exceptions jsaddle lens mtl text
  ];
  testHaskellDepends = [ base jsaddle jsaddle-warp lens text ];
  homepage = "https://github.com/input-output-hk/cardano-addresses#readme";
  description = "Javascript FFI for cardano-addresses";
  license = lib.licenses.asl20;
}
