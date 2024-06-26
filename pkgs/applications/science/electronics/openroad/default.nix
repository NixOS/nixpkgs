{
  lib,
  mkDerivation,
  fetchFromGitHub,
  fetchpatch,
  bison,
  cmake,
  doxygen,
  flex,
  git,
  python3,
  swig4,
  boost179,
  cbc, # for clp
  cimg,
  clp, # for or-tools
  eigen,
  glpk,
  gtest,
  lcov,
  lemon-graph,
  libjpeg,
  or-tools,
  pcre,
  pkg-config,
  qtbase,
  re2, # for or-tools
  readline,
  spdlog,
  tcl,
  tcllib,
  xorg,
  yosys,
  zlib,
}:

mkDerivation rec {
  pname = "openroad";
  version = "unstable-2023-08-26";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    rev = "6dba515c2aacd3fca58ef8135424884146efd95b";
    fetchSubmodules = true;
    hash = "sha256-LAj7X+Vq0+H3tIo5zgyUuIjQwTj+2DLL18/KMJ/kf4A=";
  };

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    flex
    git
    pkg-config
    swig4
  ];

  buildInputs = [
    boost179
    cbc
    cimg
    clp
    eigen
    glpk
    lcov
    lemon-graph
    libjpeg
    or-tools
    pcre
    python3
    qtbase
    re2
    readline
    spdlog
    tcl
    tcllib
    yosys
    xorg.libX11
    zlib
  ];

  patches = [
    # https://github.com/The-OpenROAD-Project/OpenROAD/pull/3911
    (fetchpatch {
      name = "openroad-fix-fmt-10.patch";
      url = "https://github.com/The-OpenROAD-Project/OpenROAD/commit/9396f07f28e0260cd64acfc51909f6566b70e682.patch";
      hash = "sha256-jy8K8pdhSswVz6V6otk8JAI7nndaFVMuKQ/4A3Kzwns=";
    })
    # Upstream is not aware of these failures
    ./0001-Disable-failing-regression-tests.patch
    # This is an issue we experience in the sandbox, and upstream
    # probably wouldn't mind merging this change, but no PR was opened.
    ./0002-Ignore-warning-on-stderr.patch
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
    "-DUSE_CIMG_LIB=ON"
    "-DOPENROAD_VERSION=${src.rev}"
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
    maintainers = with maintainers; [ trepetti ];
    platforms = platforms.linux;
  };
}
