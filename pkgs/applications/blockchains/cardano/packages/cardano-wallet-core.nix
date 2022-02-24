{ mkDerivation, aeson, aeson-qq, async, base, base16-bytestring
, base58-bytestring, bech32, bech32-th, binary, bytestring
, cardano-addresses, cardano-api, cardano-binary, cardano-crypto
, cardano-crypto-class, cardano-crypto-test, cardano-ledger-alonzo
, cardano-ledger-byron, cardano-ledger-byron-test
, cardano-ledger-core, cardano-ledger-shelley
, cardano-ledger-shelley-test, cardano-numeric, cardano-sl-x509
, cardano-slotting, cardano-wallet-launcher
, cardano-wallet-test-utils, cborg, connection, containers
, contra-tracer, criterion, cryptonite, data-default, dbvar
, deepseq, digest, directory, either, errors, exact-combinatorics
, exceptions, extra, fast-logger, fetchgit, file-embed, filepath
, fmt, foldl, generic-arbitrary, generic-lens, generics-sop
, hashable, hedgehog, hedgehog-quickcheck, hspec, hspec-core
, hspec-discover, hspec-hedgehog, http-api-data, http-client
, http-client-tls, http-media, http-types, int-cast, io-classes
, io-sim, iohk-monitoring, lattices, lens, lib, math-functions
, memory, monad-logger, MonadRandom, mtl, network, network-uri
, nothunks, ntp-client, OddWord, openapi3, ouroboros-consensus
, ouroboros-network, path-pieces, persistent, persistent-sqlite
, persistent-template, plutus-ledger-api, pretty-simple
, profunctors, QuickCheck, quickcheck-classes
, quickcheck-state-machine, quiet, random, random-shuffle
, regex-pcre-builtin, resource-pool, retry, safe, scientific
, scrypt, servant, servant-client, servant-openapi3, servant-server
, should-not-typecheck, split, splitmix, statistics, stm
, streaming-commons, strict-containers, strict-non-empty-containers
, strict-stm, string-interpolate, string-qq, template-haskell
, temporary, text, text-class, time, tls, tracer-transformers
, transformers, tree-diff, typed-protocols, unliftio, unliftio-core
, unordered-containers, vector, wai, wai-extra, warp, warp-tls
, wide-word, Win32-network, x509, x509-store, x509-validation, yaml
}:
mkDerivation {
  pname = "cardano-wallet-core";
  version = "2022.1.18";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-wallet/";
    sha256 = "1apzfy7qdgf6l0lb3icqz3rvaq2w3a53xq6wvhqnbfi8i7cacy03";
    rev = "a5085acbd2670c24251cf8d76a4e83c77a2679ba";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/lib/core; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson async base base16-bytestring bech32 bech32-th binary
    bytestring cardano-addresses cardano-api cardano-binary
    cardano-crypto cardano-crypto-class cardano-crypto-test
    cardano-ledger-alonzo cardano-ledger-byron-test cardano-ledger-core
    cardano-ledger-shelley cardano-ledger-shelley-test cardano-numeric
    cardano-slotting cardano-wallet-test-utils cborg containers
    contra-tracer cryptonite data-default dbvar deepseq digest
    directory either errors exact-combinatorics exceptions extra
    fast-logger file-embed filepath fmt foldl generic-arbitrary
    generic-lens generics-sop hashable hedgehog hedgehog-quickcheck
    http-api-data http-client http-client-tls http-media http-types
    int-cast io-classes iohk-monitoring lattices math-functions memory
    monad-logger MonadRandom mtl network network-uri nothunks
    ntp-client OddWord ouroboros-consensus ouroboros-network
    path-pieces persistent persistent-sqlite persistent-template
    plutus-ledger-api pretty-simple profunctors QuickCheck quiet random
    random-shuffle resource-pool retry safe scientific scrypt servant
    servant-client servant-server split splitmix statistics stm
    streaming-commons strict-containers strict-non-empty-containers
    strict-stm string-interpolate template-haskell text text-class time
    tls tracer-transformers transformers typed-protocols unliftio
    unliftio-core unordered-containers vector wai warp warp-tls
    wide-word Win32-network x509 x509-store x509-validation
  ];
  testHaskellDepends = [
    aeson aeson-qq base base58-bytestring binary bytestring
    cardano-addresses cardano-api cardano-binary cardano-crypto
    cardano-crypto-class cardano-ledger-byron cardano-ledger-byron-test
    cardano-ledger-core cardano-ledger-shelley
    cardano-ledger-shelley-test cardano-numeric cardano-sl-x509
    cardano-slotting cardano-wallet-launcher cardano-wallet-test-utils
    cborg connection containers contra-tracer cryptonite data-default
    deepseq directory extra file-embed filepath fmt foldl
    generic-arbitrary generic-lens generics-sop hedgehog
    hedgehog-quickcheck hspec hspec-core hspec-hedgehog http-api-data
    http-client http-client-tls http-media http-types int-cast
    io-classes io-sim iohk-monitoring lattices lens memory MonadRandom
    network network-uri nothunks OddWord openapi3 ouroboros-consensus
    persistent plutus-ledger-api pretty-simple QuickCheck
    quickcheck-classes quickcheck-state-machine quiet random
    regex-pcre-builtin retry safe scrypt servant servant-openapi3
    servant-server should-not-typecheck splitmix
    strict-non-empty-containers string-qq temporary text text-class
    time tls transformers tree-diff unliftio unliftio-core
    unordered-containers wai wai-extra warp x509 x509-store yaml
  ];
  testToolDepends = [ hspec-discover ];
  benchmarkHaskellDepends = [
    base bytestring cardano-addresses cardano-crypto
    cardano-wallet-launcher cardano-wallet-test-utils containers
    contra-tracer criterion cryptonite deepseq directory filepath fmt
    iohk-monitoring memory random text text-class time transformers
    unliftio
  ];
  homepage = "https://github.com/input-output-hk/cardano-wallet";
  description = "The Wallet Backend for a Cardano node";
  license = lib.licenses.asl20;
}
