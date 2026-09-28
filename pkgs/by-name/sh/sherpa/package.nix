{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
  libzip,
  lhapdf,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sherpa";
  version = "3.0.4";

  src = fetchFromGitLab {
    owner = "sherpa-team";
    repo = "sherpa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iXVP0XwgEpBWZ3vHq+7F9RGx6akShSizBIGkPIOw/r0=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    sed -i -e '/sys\/sysctl.h/d' ATOOLS/Org/Run_Parameter.C
  '';

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    libzip
    lhapdf
  ];

  cmakeFlags = [
    # Needed to initialize a valid SHERPA_LIBRARY_PATH
    "-DCMAKE_INSTALL_LIBDIR=lib"
    (lib.cmakeFeature "CMAKE_INSTALL_NAME_DIR" "${placeholder "out"}/lib/SHERPA-MC")
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Monte Carlo event generator for the Simulation of High-Energy Reactions of PArticles";
    license = lib.licenses.gpl3Plus;
    homepage = "https://gitlab.com/sherpa-team/sherpa";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
