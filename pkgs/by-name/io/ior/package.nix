{
  lib,
  stdenv,
  fetchFromGitHub,
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
