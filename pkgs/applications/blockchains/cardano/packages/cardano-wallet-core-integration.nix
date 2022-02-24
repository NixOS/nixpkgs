{ mkDerivation, aeson, aeson-qq, base, base16-bytestring
, base58-bytestring, bech32, bech32-th, bytestring
, cardano-addresses, cardano-api, cardano-crypto
, cardano-crypto-class, cardano-ledger-alonzo, cardano-ledger-core
, cardano-wallet-cli, cardano-wallet-core, cardano-wallet-launcher
, cardano-wallet-test-utils, cborg, command, containers
, criterion-measurement, cryptonite, deepseq, directory, either
, extra, fetchgit, filepath, flat, fmt, generic-lens
, generic-lens-core, hspec, hspec-expectations-lifted
, http-api-data, http-client, http-types, HUnit, iohk-monitoring
, lens-aeson, lib, memory, microstache, network-uri
, optparse-applicative, process, resourcet, retry, say, scrypt
, serialise, string-interpolate, template-haskell, text, text-class
, time, unliftio, unliftio-core, unordered-containers
}:
mkDerivation {
  pname = "cardano-wallet-core-integration";
  version = "2022.1.18";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/core-integration; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson aeson-qq base base16-bytestring base58-bytestring bech32
    bech32-th bytestring cardano-addresses cardano-api cardano-crypto
    cardano-crypto-class cardano-ledger-alonzo cardano-ledger-core
    cardano-wallet-cli cardano-wallet-core cardano-wallet-launcher
    cardano-wallet-test-utils cborg command containers
    criterion-measurement cryptonite deepseq directory either extra
    filepath flat fmt generic-lens generic-lens-core hspec
    hspec-expectations-lifted http-api-data http-client http-types
    HUnit iohk-monitoring lens-aeson memory microstache network-uri
    optparse-applicative process resourcet retry say scrypt serialise
    string-interpolate template-haskell text text-class time unliftio
    unliftio-core unordered-containers
  ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Core integration test library";
  license = lib.licenses.asl20;
}
