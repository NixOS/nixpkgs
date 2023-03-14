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
, cimg
, eigen
, lcov
, lemon-graph
, libjpeg
, pcre
, qtbase
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
  version = "unstable-2022-07-19";

  src = fetchFromGitHub {
    owner = "The-OpenROAD-Project";
    repo = "OpenROAD";
    rev = "2610b3953ef62651825d89fb96917cf5d20af0f1";
    fetchSubmodules = true;
    sha256 = "sha256-BP0JSnxl1XyqHzDY4eITaGHevqd+rbjWZy/LAfDfELs=";
  };

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    flex
    git
    swig4
  ];

  buildInputs = [
    boost17x
    cimg
    eigen
    lcov
    lemon-graph
    libjpeg
    pcre
    python3
    qtbase
    readline
    spdlog
    tcl
    tcllib
    yosys
    xorg.libX11
    zlib
  ];

  postPatch = ''
    patchShebangs --build etc/find_messages.py
  '';

  # Enable output images from the placer.
  cmakeFlags = [
    "-DUSE_SYSTEM_BOOST=ON"
    "-DUSE_CIMG_LIB=ON"
    "-DOPENROAD_VERSION=${src.rev}"
  ];

  # Resynthesis needs access to the Yosys binaries.
  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ yosys ]}" ];

  # Upstream uses vendored package versions for some dependencies, so regression testing is prudent
  # to see if there are any breaking changes in unstable that should be vendored as well.
  doCheck = false; # Disabled pending upstream release with fix for rcx log file creation.
  checkPhase = ''
    # Regression tests must be run from the project root not from within the CMake build directory.
    cd ..
    test/regression
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
