{
  lib,
  fetchFromGitHub,
  fontconfig,
  llvmPackages,
  nix-update-script,
  stdenv,

  # buildInputs
  fmt,
  jrl-cmakemodules,
  mimalloc,

  # propagatedBuildInputs
  crocoddyl,
  pinocchio,

  # checkInputs
  catch2_3,
  gbenchmark,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aligator";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "Simple-Robotics";
    repo = "aligator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OeLeNXLPUDs907DHDOUE3r0G39e+nxF7HTSQjXYEryE=";
  };

  outputs = [
    "doc"
    "out"
  ];

  strictDeps = true;

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    fmt
    jrl-cmakemodules
    mimalloc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  propagatedBuildInputs = [
    crocoddyl
    pinocchio
  ];

  checkInputs = [
    catch2_3
    gbenchmark
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_WITH_PINOCCHIO_SUPPORT" true)
    (lib.cmakeBool "BUILD_CROCODDYL_COMPAT" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_WITH_OPENMP_SUPPORT" true)
    (lib.cmakeBool "BUILD_WITH_CHOLMOD_SUPPORT" true)
    (lib.cmakeBool "GENERATE_PYTHON_STUBS" false) # this need git at configure time
  ];

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  preBuild = ''
    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)

    # Fontconfig error: No writable cache directories
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Versatile and efficient framework for constrained trajectory optimization";
    homepage = "https://github.com/Simple-Robotics/aligator";
    changelog = "https://github.com/Simple-Robotics/aligator/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
