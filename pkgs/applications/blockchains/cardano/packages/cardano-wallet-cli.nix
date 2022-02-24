{ mkDerivation, aeson, aeson-pretty, ansi-terminal, base
, bytestring, cardano-addresses, cardano-addresses-cli
, cardano-wallet-core, cardano-wallet-test-utils, containers
, directory, fetchgit, filepath, fmt, hspec, hspec-discover
, http-client, iohk-monitoring, lib, optparse-applicative
, QuickCheck, servant-client, servant-client-core, text, text-class
, time, unliftio
}:
mkDerivation {
  pname = "cardano-wallet-cli";
  version = "2022.1.18";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/cli; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson aeson-pretty ansi-terminal base bytestring cardano-addresses
    cardano-addresses-cli cardano-wallet-core directory filepath fmt
    http-client iohk-monitoring optparse-applicative servant-client
    servant-client-core text text-class time unliftio
  ];
  testHaskellDepends = [
    base cardano-wallet-core cardano-wallet-test-utils containers
    filepath hspec optparse-applicative QuickCheck text text-class
    unliftio
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Utilities for a building Command-Line Interfaces";
  license = lib.licenses.asl20;
}
