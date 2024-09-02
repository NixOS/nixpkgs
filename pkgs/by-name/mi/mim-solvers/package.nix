{
  cmake,
  crocoddyl,
  fetchFromGitHub,
  lib,
  llvmPackages,
  pkg-config,
  proxsuite,
  python3Packages,
  pythonSupport ? false,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mim-solvers";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "machines-in-motion";
    repo = "mim_solvers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XV8EJqCOTYqljZe2PQvnhIaPUOJ+bBjRIoshdeqZycA=";
  };

  postPatch = lib.optionalString (!pythonSupport) ''
    # eigenpy is not used without python support
    substituteInPlace CMakeLists.txt --replace-fail \
      "add_project_dependency(eigenpy 2.7.10 REQUIRED)" \
      ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = lib.optional stdenv.isDarwin llvmPackages.openmp;
  propagatedBuildInputs =
    lib.optionals pythonSupport [
      python3Packages.crocoddyl
      python3Packages.osqp
      python3Packages.proxsuite
      python3Packages.scipy
      python3Packages.pythonImportsCheckHook
    ]
    ++ lib.optionals (!pythonSupport) [
      crocoddyl
      proxsuite
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_PROXSUITE" true)
  ];

  doCheck = true;
  pythonImportsCheck = [ "mim_solvers" ];

  meta = {
    description = "Implementation of numerical solvers used in the Machines in Motion Laboratory";
    homepage = "https://github.com/machines-in-motion/mim_solvers";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "mim-solvers";
    platforms = lib.platforms.all;
  };
})
