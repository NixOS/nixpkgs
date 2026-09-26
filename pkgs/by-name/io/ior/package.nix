{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  mpi,
  perl,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ior";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = "ior";
    tag = finalAttrs.version;
    hash = "sha256-WsfJWHHfkiHZ+rPk6ck6mDErTXwt6Dhgm+yqOtw4Fvo=";
  };

  patches = [
    # Fix gcc-15 build:
    #   https://github.com/hpc/ior/pull/525
    (fetchpatch {
      name = "gcc-15.patch";
      url = "https://github.com/hpc/ior/commit/526c5ad06695a91a27163c520ce3305109f50bef.patch";
      hash = "sha256-HvbRMt2EcuO7kxLL9qKpozpNKEOmWuHkKQTSUhfU7/w=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    mpi
    perl
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://ior.readthedocs.io/en/latest/";
    description = "Parallel file system I/O performance test";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bzizou ];
  };
})
