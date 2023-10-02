{ lib
, stdenv
, fetchFromGitHub
, testers
, cmake
, gsl
, libtool
, findutils
, llvmPackages
, mpi
, nest
, pkg-config
, boost
, python3
, readline
, autoPatchelfHook
, withPython ? false
, withMpi ? false
}:

stdenv.mkDerivation rec {
  pname = "nest";
  version = "3.6";

  src = fetchFromGitHub {
    owner = "nest";
    repo = "nest-simulator";
    rev = "v${version}";
    hash = "sha256-sXtF4JmHYoLp0t3o4KF6R2E0qLnKrzSPMXOxVJAm+sU=";
  };

  postPatch = ''
    patchShebangs cmake/CheckFiles/check_return_val.sh
    # fix PyNEST installation path
    # it expects CMAKE_INSTALL_LIBDIR to be relative
    substituteInPlace cmake/ProcessOptions.cmake \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/python" "lib/python"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    findutils
  ];

  buildInputs = [
    gsl
    readline
    libtool # libltdl
    boost
  ] ++ lib.optionals withPython [
    python3
    python3.pkgs.cython
  ] ++ lib.optional withMpi mpi
    ++ lib.optional stdenv.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = with python3.pkgs; [
    numpy
  ];

  cmakeFlags = [
    "-Dwith-python=${if withPython then "ON" else "OFF"}"
    "-Dwith-mpi=${if withMpi then "ON" else "OFF"}"
    "-Dwith-openmp=ON"
  ];

  postInstall = ''
    # Alternative to autoPatchElf, moves libraries where
    # Nest expects them to be
    find $out/lib/nest -exec ln -s {} $out/lib \;
  '';

  passthru.tests.version = testers.testVersion {
    package = nest;
    command = "nest --version";
  };

  meta = with lib; {
    description = "NEST is a command line tool for simulating neural networks";
    homepage = "https://www.nest-simulator.org/";
    changelog = "https://github.com/nest/nest-simulator/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jiegec davidcromp ];
    platforms = platforms.unix;
  };
}
