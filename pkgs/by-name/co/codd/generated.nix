{
  mkDerivation,
  aeson,
  aeson-pretty,
  ansi-terminal,
  attoparsec,
  base,
  bytestring,
  clock,
  containers,
  criterion-measurement,
  deepseq,
  dlist,
  filepath,
  formatting,
  hashable,
  haxl,
  hspec,
  hspec-core,
  hspec-expectations,
  lib,
  mtl,
  network-uri,
  optparse-applicative,
  postgresql-libpq,
  postgresql-simple,
  QuickCheck,
  random,
  resourcet,
  statistics,
  streaming,
  text,
  time,
  transformers,
  typed-process,
  unliftio,
  unliftio-core,
  unordered-containers,
  uuid,
  vector,
}:
mkDerivation {
  pname = "codd";
  version = "0.1.6";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    aeson-pretty
    ansi-terminal
    attoparsec
    base
    bytestring
    clock
    containers
    deepseq
    dlist
    filepath
    formatting
    hashable
    haxl
    mtl
    network-uri
    postgresql-libpq
    postgresql-simple
    resourcet
    streaming
    text
    time
    transformers
    unliftio
    unliftio-core
    unordered-containers
    vector
  ];
  executableHaskellDepends = [
    base
    optparse-applicative
    postgresql-simple
    text
    time
  ];
  testHaskellDepends = [
    aeson
    attoparsec
    base
    containers
    filepath
    hashable
    hspec
    hspec-core
    mtl
    network-uri
    postgresql-simple
    QuickCheck
    random
    resourcet
    streaming
    text
    time
    typed-process
    unliftio
    uuid
  ];
  benchmarkHaskellDepends = [
    aeson
    base
    criterion-measurement
    deepseq
    hspec
    hspec-core
    hspec-expectations
    statistics
    streaming
    text
    vector
  ];
  homepage = "https://github.com/mzabani/codd#readme";
  license = lib.licenses.bsd3;
  mainProgram = "codd";
}
