{
  mkDerivation,
  ansi-terminal,
  base,
  bytestring,
  c,
  containers,
  fetchgit,
  file-embed,
  hashable,
  hs-highlight,
  lib,
  libffi,
  list-t,
  mtl,
  parsec,
  process,
  time,
  transformers,
  unix,
  unordered-containers,
}:
mkDerivation {
  pname = "HVM3";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/higherorderco/hvm3.git";
    sha256 = "1300s9pl866srj8cq17ilqr8p725fqcv3588dg3m0ibvy3a0qaf0";
    rev = "05268972f38b75a301381fcd86331e4916fa81e3";
    fetchSubmodules = true;
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    ansi-terminal
    base
    bytestring
    containers
    file-embed
    hashable
    hs-highlight
    libffi
    list-t
    mtl
    parsec
    process
    time
    transformers
    unix
    unordered-containers
  ];
  executableSystemDepends = [ c ];
  homepage = "https://higherorderco.com/";
  license = lib.licenses.mit;
}
