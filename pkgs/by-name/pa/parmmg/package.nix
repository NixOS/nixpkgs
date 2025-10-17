{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  perl,
  mpi,
  metis,
  mmg,
  scotch,
  vtk,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "parmmg";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "MmgTools";
    repo = "ParMmg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LDbfGuTRd2wzmNHxXd381qVuOlWqqDdP8+Y/v1H68uM=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs --build scripts
  '';

  nativeBuildInputs = [
    cmake
    gfortran
    perl
  ];

  buildInputs = [
    mpi
    metis
    mmg
  ];

  propagateBuildInputs = [
    scotch
    vtk
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "DOWNLOAD_MMG" false)
    (lib.cmakeBool "DOWNLOAD_METIS" false)
    (lib.cmakeBool "USE_ELAS" false)
    (lib.cmakeBool "USE_VTK" true)
    (lib.cmakeBool "USE_SCOTCH" true)
  ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "ParMmg" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Distributed parallelization of 3D volume mesh adaptation";
    homepage = "http://www.mmgtools.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ mkez ];
  };
})
