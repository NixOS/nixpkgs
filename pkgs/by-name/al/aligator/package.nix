{
  lib,
  fetchFromGitHub,
  fontconfig,
  llvmPackages,
  nix-update-script,
  stdenv,

  # nativeBuildInputs
  doxygen,
  cmake,
  graphviz,
  pkg-config,

  # buildInputs
  fmt,
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
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "Simple-Robotics";
    repo = "aligator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8DO+lfM4mk4bA/IOEJlLaOp9snCUBHiw7RRcYEwJC7c=";
  };

  # aligator 0.19.0 expect gbenchmark 1.9.5, which is not merged yet:
  # https://github.com/NixOS/nixpkgs/pull/506375
  postPatch = ''
    substituteInPlace \
        bench/lqr.cpp \
        bench/se2-car.cpp \
        bench/talos-walk.cpp \
        bench/croc-talos-arm.cpp \
        bench/gar-riccati.cpp \
      --replace-fail \
        "benchmark::Benchmark" \
        "benchmark::internal::Benchmark"
  '';

  outputs = [
    "doc"
    "out"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    doxygen
    cmake
    graphviz
    pkg-config
  ];

  buildInputs = [
    fmt
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

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_WITH_PINOCCHIO_SUPPORT" true)
    (lib.cmakeBool "BUILD_CROCODDYL_COMPAT" true)
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
