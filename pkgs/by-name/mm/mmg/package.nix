{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  scotch,
  vtk,
  withVtk ? false,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mmg";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "MmgTools";
    repo = "mmg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jiOScvzyO+bN2wYwcQmWhLkLSkTWVplMrXKRFttGisw=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  postPatch = ''
    patchShebangs --build scripts
  '';

  nativeBuildInputs = [
    cmake
    perl # required for generating fortran headers
  ];

  propagatedBuildInputs = [
    scotch
  ]
  ++ lib.optional withVtk vtk;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "MMG_INSTALL_PRIVATE_HEADERS" true) # required by downstream parmmg
    (lib.cmakeBool "USE_ELAS" false)
    (lib.cmakeBool "USE_SCOTCH" true)
    (lib.cmakeBool "USE_VTK" withVtk)
    (lib.cmakeBool "PMMG_CALL" vtk.mpiSupport)
  ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "mmg" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Open source software for bidimensional and tridimensional remeshing";
    homepage = "http://www.mmgtools.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ mkez ];
  };
})
