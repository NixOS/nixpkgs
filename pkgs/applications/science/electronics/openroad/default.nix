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
  boost180,
  cbc, # for clp
  cimg,
  clp, # for or-tools
  cudd,
  eigen,
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
  version = "2.0-unstable-2024-12-22";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    rev = "51302eb80b11576a01171d33452c362301d55143";
    fetchSubmodules = true;
    hash = "sha256-xFeZo6GjKKee7fTrzN4TNNL8eeTDJXyQGPkIKU/WvIc=";
  };

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    flex
    git
    pkg-config
    swig
  ];

  buildInputs = [
    boost180
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

  # Enable output images from the placer.
  cmakeFlags = [
    # Tries to download gtest 1.13 as part of the build. We currently rely on
    # the regression tests so we can get by without building unit tests.
    "-DENABLE_TESTS=OFF"
    "-DUSE_SYSTEM_BOOST=ON"
    "-DUSE_SYSTEM_ABC=OFF"
    "-DUSE_SYSTEM_OPENSTA=OFF"
    "-DOPENROAD_VERSION=${src.rev}"
    "-DTCL_LIBRARY=${tcl}/lib/libtcl.so"
    "-DTCL_HEADER=${tcl}/include/tcl.h"
  ];

  # Resynthesis needs access to the Yosys binaries.
  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ yosys ]}" ];

  # Upstream uses vendored package versions for some dependencies, so regression testing is prudent
  # to see if there are any breaking changes in unstable that should be vendored as well.
  doCheck = true;
  checkPhase = ''
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
