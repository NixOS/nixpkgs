{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  tk,
  hdf5,
  xorg,
  libGLU,
  withTools ? false,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cgns";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "cgns";
    repo = "cgns";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lPbXIC+O4hTtacxUcyNjZUWpEwo081MjEWhfIH3MWus=";
  };

  postPatch = ''
    substituteInPlace src/cgnstools/tkogl/tkogl.c \
      --replace-fail "<tk-private/generic/tkInt.h>" "<tkInt.h>"
  '';

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs =
    [
      hdf5
    ]
    ++ lib.optionals withTools [
      tk
      xorg.libXmu
      libGLU
    ];

  cmakeFlags = [
    (lib.cmakeBool "CGNS_ENABLE_FORTRAN" true)
    (lib.cmakeBool "CGNS_ENABLE_LEGACY" true)
    (lib.cmakeBool "CGNS_ENABLE_HDF5" true)
    (lib.cmakeBool "HDF5_NEED_MPI" hdf5.mpiSupport)
    (lib.cmakeBool "CGNS_BUILD_CGNSTOOLS" withTools)
    (lib.cmakeBool "CGNS_ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "CGNS_BUILD_SHARED" (!stdenv.hostPlatform.isStatic))
  ];

  doCheck = true;

  enableParallelChecking = false;

  # Remove broken .desktop files
  postFixup = ''
    rm -f $out/bin/*.desktop
  '';

  passthru.tests.cmake-config = testers.hasCmakeConfigModules {
    moduleNames = [ "cgns" ];
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "CFD General Notation System standard library";
    homepage = "https://cgns.github.io";
    downloadPage = "https://github.com/cgns/cgns";
    changelog = "https://github.com/cgns/cgns/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ zlib ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
