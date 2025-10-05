{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  bison,
  cmake,
  doxygen,
  flex,
  gitMinimal,
  gtest,
  libsForQt5,
  pkg-config,
  swig,

  # buildInputs
  boost186, # 1.87.0 broken https://github.com/boostorg/asio/issues/442
  cbc, # for clp
  cimg,
  clp, # for or-tools
  cudd,
  eigen,
  glpk,
  lcov,
  lemon-graph,
  libjpeg,
  or-tools,
  pcre,
  python3,
  re2, # for or-tools
  readline,
  spdlog,
  tcl,
  tclPackages,
  yosys,
  zlib,
  xorg,
  llvmPackages,
}:

stdenv.mkDerivation rec {
  pname = "openroad";
  version = "2.0-unstable-2025-03-01";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    rev = "e794373d44ac5421f0633d8dda7e5c59e8fe79bf";
    fetchSubmodules = true;
    hash = "sha256-a/X4FHkbiqHeblse2ZkLT56gYP+LCrAIZVCdsWF59jM=";
  };

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    flex
    gitMinimal
    gtest
    libsForQt5.wrapQtAppsHook
    pkg-config
    swig
  ];

  buildInputs = [
    boost186
    cbc
    cimg
    clp
    cudd
    eigen
    glpk
    lcov
    lemon-graph
    libjpeg
    libsForQt5.qtbase
    libsForQt5.qtcharts
    libsForQt5.qtdeclarative
    libsForQt5.qtsvg
    or-tools
    pcre
    python3
    re2
    readline
    spdlog
    tcl
    tclPackages.tclreadline
    yosys
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  postPatch = ''
    patchShebangs --build etc/find_messages.py
    # Disable two tests that are failing curently.
    sed 's/^.*partition_gcd/# \0/g' -i src/par/test/CMakeLists.txt
  '';

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" true)
    (lib.cmakeBool "USE_SYSTEM_BOOST" true)
    (lib.cmakeBool "USE_SYSTEM_ABC" false)
    (lib.cmakeBool "ABC_SKIP_TESTS" true) # it attempts to download gtest
    (lib.cmakeBool "USE_SYSTEM_OPENSTA" false)
    (lib.cmakeFeature "OPENROAD_VERSION" "${version}_${src.rev}")
    (lib.cmakeBool "CMAKE_RULE_MESSAGES" false)
    (lib.cmakeFeature "TCL_HEADER" "${tcl}/include/tcl.h")
    (lib.cmakeFeature "TCL_LIBRARY" "${tcl}/lib/libtcl${stdenv.hostPlatform.extensions.sharedLibrary}")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DBOOST_STACKTRACE_GNU_SOURCE_NOT_REQUIRED")
  ];

  # Resynthesis needs access to the Yosys binaries.
  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ yosys ]}" ];

  # Upstream uses vendored package versions for some dependencies, so regression testing is prudent
  # to see if there are any breaking changes in unstable that should be vendored as well.
  doCheck = !stdenv.hostPlatform.isDarwin; # it seems to hang on darwin
  checkPhase = ''
    make test
    ../test/regression
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/openroad -version
    $out/bin/sta -version

    runHook postInstallCheck
  '';

  meta = {
    description = "OpenROAD's unified application implementing an RTL-to-GDS flow";
    homepage = "https://theopenroadproject.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      trepetti
      hzeller
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
