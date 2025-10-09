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
  version = "0.1.0.0";
  src = fetchzip {
    url = "https://github.com/marvinborner/bruijn/archive/31ba54046e33618905fc99e0b079bd3aa2594284.tar.gz";
    sha256 = "11b3i32y36i29haym4agn1pgik20byldihgs2qsi5p7vy17z0a78";
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
