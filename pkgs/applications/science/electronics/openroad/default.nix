{ lib
, mkDerivation
, fetchFromGitHub
, bison
, cmake
, doxygen
, flex
, git
, python3
, swig4
, boost17x
, cbc       # for clp
, cimg
, clp       # for or-tools
, eigen
, glpk
, gtest
, lcov
, lemon-graph
, libjpeg
, or-tools
, pcre
, pkg-config
, qtbase
, re2       # for or-tools
, readline
, spdlog
, tcl
, tcllib
, xorg
, yosys
, zlib
}:

mkDerivation rec {
  pname = "openroad";
  version = "unstable-2023-03-31";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    rev = "cd03c5cf8a8eb78c0e07fe33a56b8e9d64672efe";
    fetchSubmodules = true;
    hash = "sha256-BWUvFCuWKWQpifErpak03J+A7ni0jZWIrCMhMdKIbD0=";
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
    boost17x
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
    ./0001-Fix-string-formatting-in-tests.patch
    ./0002-Ignore-warning-on-stderr.patch
  ];

  postPatch = ''
    patchShebangs --build etc/find_messages.py
  '';

  # Enable output images from the placer.
  cmakeFlags = [
    "-DUSE_SYSTEM_BOOST=ON"
    "-DUSE_CIMG_LIB=ON"
    "-DOPENROAD_VERSION=${src.rev}"

    # 2023-03-31: see discussion on fmt workaround in
    # https://github.com/The-OpenROAD-Project/OpenROAD/pull/2696
    "-DCMAKE_CXX_FLAGS=-DFMT_DEPRECATED_OSTREAM"
  ];

  # Resynthesis needs access to the Yosys binaries.
  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ yosys ]}" ];

  checkInputs = [ gtest ];

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
