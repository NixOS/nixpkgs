{
  mkDerivation,
  array,
  base,
  binary,
  bitstring,
  bytestring,
  clock,
  containers,
  deepseq,
  directory,
  fetchzip,
  filepath,
  haskeline,
  lib,
  megaparsec,
  mtl,
  optparse-applicative,
  process,
  random,
  time,
}:
mkDerivation {
  pname = "bruijn";
  version = "0-unstable-2025-12-07";
  src = fetchzip {
    url = "https://github.com/marvinborner/bruijn/archive/3f329f0299c944205293eceec72be25418fd9f0b.tar.gz";
    sha256 = "0qx7x50bz0yw0iwg4ymxipzqbh7ki729rbfwxrmijnwbxijlsr01";
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    array
    base
    binary
    bitstring
    bytestring
    clock
    containers
    deepseq
    directory
    filepath
    haskeline
    megaparsec
    mtl
    optparse-applicative
    process
    random
    time
  ];
  executableHaskellDepends = [
    array
    base
    binary
    bitstring
    bytestring
    clock
    containers
    deepseq
    directory
    filepath
    haskeline
    megaparsec
    mtl
    optparse-applicative
    process
    random
    time
  ];
  homepage = "https://github.com/githubuser/bruijn#readme";
  license = lib.licenses.mit;
  mainProgram = "bruijn";
  maintainers = [ lib.maintainers.defelo ];
}
