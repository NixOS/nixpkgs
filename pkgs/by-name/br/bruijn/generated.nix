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
    url = "https://github.com/marvinborner/bruijn/archive/7d37a689cebcfa81821455ea7779a8052f7e1ab1.tar.gz";
    sha256 = "06rjlvwfyc2czc09r5sw9xiajlgpd1cma8qqj7v5af8dc1x1jxx5";
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
