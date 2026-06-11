# This file has been autogenerate with cabal2nix.
# Update via ./update.sh"
{
  mkDerivation,
  ansi-terminal,
  async,
  attoparsec,
  base,
  bytestring,
  cassava,
  containers,
  directory,
  extra,
  fetchzip,
  filelock,
  filepath,
  hermes-json,
  HUnit,
  lib,
  MemoTrie,
  nix-derivation,
  optics,
  random,
  relude,
  safe,
  safe-exceptions,
  stm,
  streamly-core,
  strict,
  strict-types,
  terminal-size,
  text,
  time,
  transformers,
  typed-process,
  unix,
  word8,
}:
mkDerivation {
  pname = "nix-output-monitor";
  version = "2.1.8";
  src = fetchzip {
    url = "https://code.maralorn.de/maralorn/nix-output-monitor/archive/v2.1.8.tar.gz";
    sha256 = "09zpz9dbllaqngkg6hz0vl4sx3kbvlp4cdk6lqa0kgszrwsdwl9r";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    directory
    extra
    filelock
    filepath
    hermes-json
    MemoTrie
    nix-derivation
    optics
    relude
    safe
    safe-exceptions
    stm
    streamly-core
    strict
    strict-types
    terminal-size
    text
    time
    transformers
    word8
  ];
  executableHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    directory
    extra
    filelock
    filepath
    hermes-json
    MemoTrie
    nix-derivation
    optics
    relude
    safe
    safe-exceptions
    stm
    streamly-core
    strict
    strict-types
    terminal-size
    text
    time
    transformers
    typed-process
    unix
    word8
  ];
  testHaskellDepends = [
    ansi-terminal
    async
    attoparsec
    base
    bytestring
    cassava
    containers
    directory
    extra
    filelock
    filepath
    hermes-json
    HUnit
    MemoTrie
    nix-derivation
    optics
    random
    relude
    safe
    safe-exceptions
    stm
    streamly-core
    strict
    strict-types
    terminal-size
    text
    time
    transformers
    typed-process
    word8
  ];
  homepage = "https://code.maralorn.de/maralorn/nix-output-monitor";
  description = "Processes output of Nix commands to show helpful and pretty information";
  license = lib.licenses.agpl3Plus;
  mainProgram = "nom";
  maintainers = [ lib.maintainers.maralorn ];
}
