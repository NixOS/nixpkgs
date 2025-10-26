{
  lib,
  stdenv,
  fetchpatch2,
  fetchFromGitHub,
  cmake,
  gfortran,
  perl,
  mpi,
  metis,
  mmg,
  scotch,
  vtk-full,
  withVtk ? true,
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

  patches = [
    (fetchpatch2 {
      url = "https://github.com/MmgTools/ParMmg/commit/a9551c502c58a1f8a109fb17d8f45cb9370f8fc6.patch?full_index=1";
      hash = "sha256-i0KwzseffeI9UYIYuyNYmdF9eTZ+nQQfSI6ukSowIYs=";
    })
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
    scotch
    (mmg.override {
      inherit withVtk;
      vtk = vtk-full;
    })
  ]
  ++ lib.optional withVtk vtk-full;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "DOWNLOAD_MMG" false)
    (lib.cmakeBool "DOWNLOAD_METIS" false)
    (lib.cmakeBool "USE_ELAS" false)
    (lib.cmakeBool "USE_SCOTCH" true)
    (lib.cmakeBool "USE_VTK" withVtk)
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
