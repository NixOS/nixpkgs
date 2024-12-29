{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  gfortran,
  perl,
  mpi,
  metis,
  mmg,
}:
stdenv.mkDerivation {
  pname = "parmmg";
  version = "1.4.0-unstable-2024-04-22";

  src = fetchFromGitHub {
    owner = "MmgTools";
    repo = "ParMmg";
    rev = "f8a5338ea1bb2c778bfb4559c2c3974ba15b4730";
    hash = "sha256-ieFHREAVeD7IwDUCtsMG5UKxahxM+wzNCAqCOHIHwu8=";
  };

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    cmake
    gfortran
    mpi
    perl
  ];

  buildInputs = [
    mpi
    metis
    mmg
  ];

  strictDeps = true;

  preConfigure = ''
    patchShebangs --build ./
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=TRUE"
    "-DDOWNLOAD_MMG=OFF"
    "-DDOWNLOAD_METIS=OFF"
    "-Wno-dev"
  ];

  meta = with lib; {
    description = "Distributed parallelization of 3D volume mesh adaptation";
    homepage = "http://www.mmgtools.org/";
    platforms = platforms.unix;
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ mkez ];
  };
}
