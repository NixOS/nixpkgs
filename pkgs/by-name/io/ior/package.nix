{
  lib,
  stdenv,
  fetchFromGitHub,
  mpi,
  perl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "ior";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "hpc";
    repo = pname;
    rev = version;
    sha256 = "sha256-pSjptDfiPlaToXe1yHyk9MQMC9PqcVSjqAmWLD11iOM=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    mpi
    perl
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://ior.readthedocs.io/en/latest/";
    description = "Parallel file system I/O performance test";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bzizou ];
  };
}
