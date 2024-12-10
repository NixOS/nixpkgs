{
  mkDerivation,
  async,
  base,
  bytestring,
  containers,
  fetchFromGitLab,
  mtl,
  parallel-io,
  parsec,
  lib,
  stm,
  transformers,
  sbv_7_13,
}:

mkDerivation rec {
  pname = "petrinizer";
  version = "0.9.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.lrz.de";
    owner = "i7";
    repo = pname;
    rev = version;
    sha256 = "1n7fzm96gq5rxm2f8w8sr1yzm1zcxpf0b473c6xnhsgqsis5j4xw";
  };

  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    async
    base
    bytestring
    containers
    mtl
    parallel-io
    parsec
    sbv_7_13
    stm
    transformers
  ];
  description = "Safety and Liveness Analysis of Petri Nets with SMT solvers";
  license = lib.licenses.gpl3;
  maintainers = with lib.maintainers; [ raskin ];
  inherit (sbv_7_13.meta) platforms;

  # dependency sbv no longer builds
  hydraPlatforms = lib.platforms.none;
  broken = true;
}
