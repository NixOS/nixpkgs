{ mkDerivation, aeson, ansi-terminal, base, base16-bytestring
, bytestring, cardano-api, cardano-cli, cardano-config
, cardano-node, cardano-submit-api, containers, directory
, exceptions, fetchgit, filepath, hedgehog, hedgehog-extras
, http-client, http-types, lib, optparse-applicative-fork
, ouroboros-network, plutus-example, process, random, resourcet
, stm, tasty, tasty-hedgehog, text, time, unix
, unordered-containers, yaml
}:
mkDerivation {
  pname = "cardano-testnet";
  version = "1.33.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/cardano-node/";
    sha256 = "1hr00wqzmcyc3x0kp2hyw78rfmimf6z4zd4vv85b9zv3nqbjgrik";
    rev = "814df2c146f5d56f8c35a681fe75e85b905aed5d";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/cardano-testnet; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base base16-bytestring bytestring cardano-node containers
    directory exceptions filepath hedgehog hedgehog-extras http-client
    http-types ouroboros-network process random resourcet text time
    unix unordered-containers yaml
  ];
  executableHaskellDepends = [
    ansi-terminal base cardano-config hedgehog hedgehog-extras
    optparse-applicative-fork resourcet stm text
  ];
  testHaskellDepends = [
    aeson base base16-bytestring bytestring cardano-api containers
    directory filepath hedgehog hedgehog-extras tasty tasty-hedgehog
    text unordered-containers
  ];
  testToolDepends = [
    cardano-cli cardano-node cardano-submit-api plutus-example
  ];
  license = lib.licenses.asl20;
}
