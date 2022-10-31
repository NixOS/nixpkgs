{ lib
, stdenv
, fetchFromGitHub
, testers
, pkg-config
, bison
, cmake
, flex
, readline
, python3
, usePython ? false
, useMpi ? false
, mpi
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "neuron${lib.optionalString useMpi "-mpi"}";
  version = "8.2.1";

  src = fetchFromGitHub {
    owner = "neuronsimulator";
    repo = "nrn";
    rev = version;
    fetchSubmodules = true;
    sha256 = "sha256-nQBwEZxEE3spV2cifmJIha9YUkXwsyg9WEZAWp9bDqA=";
  };

  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ bison flex readline ]
    ++ lib.optional useMpi mpi
    ++ lib.optional usePython python3.pkgs.cython;

  cmakeFlags = [
    "-DNRN_ENABLE_INTERVIEWS=OFF"
    "-DPYTHON_EXECUTABLE=${python3}/bin/python"
    "-DNRN_ENABLE_PYTHON=${if usePython then "ON" else "OFF"}"
    "-DNRN_ENABLE_RX3D=${if usePython then "ON" else "OFF"}"
    "-DNRN_ENABLE_MPI=${if useMpi then "ON" else "OFF"}"
  ];

  postInstall = ''
    # neuron install symlinks to $out/$arch for compatibility
    # remove it
    rm -rf $out/${stdenv.buildPlatform.uname.processor}
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "nrniv --version";
  };

  meta = with lib; {
    description = "Simulation environment for empirically-based simulations of neurons and networks of neurons";

    longDescription = "NEURON is a simulation environment for developing and exercising models of
                neurons and networks of neurons. It is particularly well-suited to problems where
                cable properties of cells play an important role, possibly including extracellular
                potential close to the membrane), and where cell membrane properties are complex,
                involving many ion-specific channels, ion accumulation, and second messengers";

    license = licenses.bsd3;
    homepage = "http://www.neuron.yale.edu/neuron";
    maintainers = [ maintainers.adev ];
    platforms = platforms.unix;
  };
})
