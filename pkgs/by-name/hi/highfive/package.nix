{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  eigen,
  hdf5,
  mpiSupport ? hdf5.mpiSupport,
  mpi ? hdf5.mpi,
}:

assert mpiSupport -> mpi != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "highfive${lib.optionalString mpiSupport "-mpi"}";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = "BlueBrain";
    repo = "HighFive";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Nv+nbel/xGlGTB8sKF0EM1xwz/ZEri5uGB7ma6Ba6fo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    eigen
    hdf5
  ];

  passthru = {
    inherit mpiSupport mpi;
  };

  cmakeFlags = [
    "-DHIGHFIVE_USE_BOOST=ON"
    "-DHIGHFIVE_USE_EIGEN=ON"
    "-DHIGHFIVE_EXAMPLES=OFF"
    "-DHIGHFIVE_UNIT_TESTS=OFF"
    "-DHIGHFIVE_USE_INSTALL_DEPS=ON"
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ]
  ++ (lib.optionals mpiSupport [ "-DHIGHFIVE_PARALLEL_HDF5=ON" ]);

  meta = {
    description = "Header-only C++ HDF5 interface";
    license = lib.licenses.boost;
    homepage = "https://bluebrain.github.io/HighFive/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ robertodr ];
  };
})
