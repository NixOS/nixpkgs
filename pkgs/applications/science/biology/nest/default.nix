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
<<<<<<< HEAD
  version = "3.5";
=======
  version = "3.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nest";
    repo = "nest-simulator";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PPUIXlU6noJRAa/twNSKVxPgIvbWl0OillEJRDzt+4s=";
=======
    hash = "sha256-+wjsZxW2l0WGyGTm/6vyzPEeqCfyxJml9oP/zn6W1L0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
