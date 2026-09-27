{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,

  eigen,
  llvmPackages,

  withShared ? (!stdenv.hostPlatform.isStatic),
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "acados";
  version = "0.6.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "acados";
    repo = "acados";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NGwiANC50eqLZgmwzP85vse0Q+gjncFNdJOVvVfi41k=";
    fetchSubmodules = true; # TODO they fork every dependency :(
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    eigen
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" withShared)
    (lib.cmakeBool "ACADOS_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ACADOS_WITH_OPENMP" true)

    # everything that works out of the box here has been enabled
    (lib.cmakeBool "ACADOS_WITH_QPOASES" false)
    (lib.cmakeBool "ACADOS_WITH_DAQP" true)
    (lib.cmakeBool "ACADOS_WITH_HPMPC" false)
    (lib.cmakeBool "ACADOS_WITH_QORE" false)
    (lib.cmakeBool "ACADOS_WITH_OOQP" false)
    (lib.cmakeBool "ACADOS_WITH_QPDUNES" true)
    (lib.cmakeBool "ACADOS_WITH_OSQP" true)
    (lib.cmakeBool "ACADOS_WITH_CLARABEL" false)
    (lib.cmakeBool "ACADOS_OCTAVE" false)

    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" # for their fork of qpdunes
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and embedded solvers for nonlinear optimal control and nonlinear model predictive control";
    homepage = "https://github.com/acados/acados";
    changelog = "https://github.com/acados/acados/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
