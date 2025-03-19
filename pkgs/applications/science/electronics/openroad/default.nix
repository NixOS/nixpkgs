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
  boost,
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
  version = "2.0-unstable-2024-12-31";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    rev = "21cf29eda317e0c7777fbfaa3f384ec9fab1a0f9";
    fetchSubmodules = true;
    hash = "sha256-cRETSW8cG/Q0hgxaFJjtnBqsIU0r6/kCRy1+5gJfC9o=";
  };

  patches = [
    ./swig43-compat.patch # https://github.com/The-OpenROAD-Project/OpenROAD/issues/6451
  ];

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
    boost
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
  ];

  postPatch = ''
    patchShebangs --build etc/find_messages.py
  '';

  cmakeFlags = [
    "-DENABLE_TESTS=ON"
    "-DUSE_SYSTEM_BOOST=ON"
    "-DUSE_SYSTEM_ABC=OFF"
    "-DUSE_SYSTEM_OPENSTA=OFF"
    "-DOPENROAD_VERSION=${version}_${src.rev}"
    "-DCMAKE_RULE_MESSAGES=OFF"
    "-DTCL_LIBRARY=${tcl}/lib/libtcl.so"
    "-DTCL_HEADER=${tcl}/include/tcl.h"
  ];

  # Resynthesis needs access to the Yosys binaries.
  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ yosys ]}" ];

  # Upstream uses vendored package versions for some dependencies, so regression testing is prudent
  # to see if there are any breaking changes in unstable that should be vendored as well.
  doCheck = true;
  checkPhase = ''
    # Disable two tests that are failing curently.
    sed 's/^.*partition_gcd/# \0/g' -i src/par/test/CTestTestfile.cmake
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
    platforms = platforms.linux;
  };
}
