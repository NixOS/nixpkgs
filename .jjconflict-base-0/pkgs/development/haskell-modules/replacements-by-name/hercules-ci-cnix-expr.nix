{
  mkDerivation,
  aeson,
  base,
  boost,
  bytestring,
  Cabal,
  cabal-pkg-config-version-hook,
  conduit,
  containers,
  directory,
  exceptions,
  filepath,
  hercules-ci-cnix-store,
  hspec,
  hspec-discover,
  inline-c,
  inline-c-cpp,
  lib,
  nix,
  process,
  protolude,
  QuickCheck,
  scientific,
  temporary,
  text,
  unliftio,
  unordered-containers,
  vector,
}:
mkDerivation {
  pname = "hercules-ci-cnix-expr";
  version = "0.3.6.5";
  sha256 = "0adbd451815bb6ea7388c0477fe6e114e0ba019819027709855e7834aedcb6df";
  setupHaskellDepends = [
    base
    Cabal
    cabal-pkg-config-version-hook
  ];
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    conduit
    containers
    directory
    exceptions
    filepath
    hercules-ci-cnix-store
    inline-c
    inline-c-cpp
    protolude
    scientific
    text
    unliftio
    unordered-containers
    vector
  ];
  librarySystemDepends = [ boost ];
  libraryPkgconfigDepends = [ nix ];
  testHaskellDepends = [
    aeson
    base
    bytestring
    containers
    filepath
    hercules-ci-cnix-store
    hspec
    process
    protolude
    QuickCheck
    scientific
    temporary
    text
    unordered-containers
    vector
  ];
  testToolDepends = [ hspec-discover ];
  homepage = "https://docs.hercules-ci.com";
  description = "Bindings for the Nix evaluator";
  license = lib.licenses.asl20;
}
