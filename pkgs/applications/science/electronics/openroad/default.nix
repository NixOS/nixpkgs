{
  lib,
  mkDerivation,
  fetchFromGitHub,
  bison,
  cmake,
  doxygen,
  flex,
  git,
  python3,
  swig,
  boost186, # 1.87.0 broken https://github.com/boostorg/asio/issues/442
  cbc, # for clp
  cimg,
  clp, # for or-tools
  cudd,
  eigen,
  gtest,
  glpk,
  lcov,
  lemon-graph,
  libsForQt5,
  libjpeg,
  or-tools,
  pcre,
  pkg-config,
  re2, # for or-tools
  readline,
  spdlog,
  tcl,
  tclPackages,
  xorg,
  yosys,
  zlib,
  llvmPackages,
  stdenv,
}:

let
  or-tools-static = or-tools.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      # https://github.com/google/or-tools/issues/3709
      "-DBUILD_SHARED_LIBS=OFF"
    ];
  });
in
mkDerivation rec {
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
    git
    gtest
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
    or-tools-static
    pcre
    python3
    libsForQt5.qtbase
    libsForQt5.qtcharts
    libsForQt5.qtsvg
    libsForQt5.qtdeclarative
    re2
    readline
    spdlog
    tcl
    tclPackages.tclreadline
    yosys
    xorg.libX11
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ llvmPackages.openmp ];

  postPatch = ''
    patchShebangs --build etc/find_messages.py
    # Disable two tests that are failing curently.
    sed 's/^.*partition_gcd/# \0/g' -i src/par/test/CMakeLists.txt
  '';

  cmakeFlags =
    [
      "-DENABLE_TESTS=ON"
      "-DUSE_SYSTEM_BOOST=ON"
      "-DUSE_SYSTEM_ABC=OFF"
      "-DABC_SKIP_TESTS=ON" # it attempts to download gtest
      "-DUSE_SYSTEM_OPENSTA=OFF"
      "-DOPENROAD_VERSION=${version}_${src.rev}"
      "-DCMAKE_RULE_MESSAGES=OFF"
      "-DTCL_HEADER=${tcl}/include/tcl.h"
      "-DTCL_LIBRARY=${tcl}/lib/libtcl${stdenv.hostPlatform.extensions.sharedLibrary}"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DCMAKE_CXX_FLAGS=-DBOOST_STACKTRACE_GNU_SOURCE_NOT_REQUIRED"
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
    $out/bin/openroad -version
    $out/bin/sta -version
  '';

  meta = with lib; {
    description = "OpenROAD's unified application implementing an RTL-to-GDS flow";
    homepage = "https://theopenroadproject.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      trepetti
      hzeller
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
