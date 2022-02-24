{ mkDerivation, aeson, ansi-wl-pprint, array, base
, base58-bytestring, bech32, bech32-th, binary, bytestring
, cardano-addresses, cardano-api, cardano-binary, cardano-crypto
, cardano-crypto-class, cardano-crypto-wrapper
, cardano-ledger-alonzo, cardano-ledger-byron, cardano-ledger-core
, cardano-ledger-shelley, cardano-ledger-shelley-ma
, cardano-slotting, cardano-wallet-cli, cardano-wallet-core
, cardano-wallet-core-integration, cardano-wallet-launcher
, cardano-wallet-test-utils, cborg, containers, contra-tracer
, deepseq, directory, either, extra, fetchgit, filepath, fmt
, generic-arbitrary, generic-lens, hspec, hspec-core
, hspec-discover, http-client, http-types, int-cast, io-classes
, iohk-monitoring, lib, lobemo-backend-ekg, memory, MonadRandom
, network, network-mux, network-uri, optparse-applicative
, ouroboros-consensus, ouroboros-consensus-byron
, ouroboros-consensus-cardano, ouroboros-consensus-shelley
, ouroboros-network, ouroboros-network-framework, pretty-simple
, QuickCheck, random, retry, say, serialise, servant-server
, strict-containers, strict-non-empty-containers, temporary, text
, text-class, time, transformers, typed-process, unliftio
, unliftio-core, unordered-containers, vector, wai-extra, warp
, Win32-network, yaml
}:
mkDerivation {
  pname = "cardano-wallet";
  version = "2022.1.18";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/shelley; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson array base base58-bytestring bech32 bech32-th binary
    bytestring cardano-addresses cardano-api cardano-binary
    cardano-crypto cardano-crypto-class cardano-crypto-wrapper
    cardano-ledger-alonzo cardano-ledger-byron cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-ma cardano-slotting
    cardano-wallet-cli cardano-wallet-core cardano-wallet-launcher
    cardano-wallet-test-utils cborg containers contra-tracer directory
    extra filepath fmt generic-lens int-cast io-classes iohk-monitoring
    memory network network-mux network-uri optparse-applicative
    ouroboros-consensus ouroboros-consensus-byron
    ouroboros-consensus-cardano ouroboros-consensus-shelley
    ouroboros-network ouroboros-network-framework random retry
    serialise servant-server strict-containers
    strict-non-empty-containers temporary text text-class time
    transformers typed-process unliftio unliftio-core
    unordered-containers vector warp Win32-network yaml
  ];
  executableHaskellDepends = [
    ansi-wl-pprint base cardano-wallet-cli cardano-wallet-core
    cardano-wallet-core-integration cardano-wallet-launcher
    contra-tracer directory filepath iohk-monitoring lobemo-backend-ekg
    network-uri optparse-applicative text text-class transformers
    unliftio wai-extra
  ];
  testHaskellDepends = [
    aeson base base58-bytestring bech32 bech32-th bytestring
    cardano-addresses cardano-api cardano-crypto cardano-crypto-class
    cardano-crypto-wrapper cardano-ledger-alonzo cardano-ledger-byron
    cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-ma cardano-wallet-cli cardano-wallet-core
    cardano-wallet-core-integration cardano-wallet-launcher
    cardano-wallet-test-utils containers contra-tracer directory either
    filepath fmt generic-arbitrary generic-lens hspec hspec-core
    http-client iohk-monitoring lobemo-backend-ekg memory MonadRandom
    network-uri optparse-applicative ouroboros-consensus-shelley
    ouroboros-network pretty-simple QuickCheck strict-containers text
    text-class time transformers unliftio
  ];
  testToolDepends = [ hspec-discover ];
  benchmarkHaskellDepends = [
    aeson base bytestring cardano-addresses cardano-wallet-cli
    cardano-wallet-core cardano-wallet-core-integration
    cardano-wallet-launcher contra-tracer deepseq directory filepath
    fmt generic-lens hspec http-client http-types iohk-monitoring say
    text text-class time transformers unliftio
  ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "Wallet backend protocol-specific bits implemented using Shelley nodes";
  license = lib.licenses.asl20;
}
