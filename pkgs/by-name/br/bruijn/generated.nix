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
  version = "0-unstable-2026-07-16";
  src = fetchzip {
    url = "https://github.com/marvinborner/bruijn/archive/9f1ac8856d09666a7444874f80b91b876929eecf.tar.gz";
    sha256 = "18mcwp2xn7wgr81mgqr38irvkf24rf0nvwzi8janasq5favim0vy";
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
