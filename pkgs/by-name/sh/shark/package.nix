{
  lib,
  boost,
  cmake,
  fetchFromGitHub,
  openssl,
  stdenv,
  enableOpenMP ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shark";
  version = "4.0-unstable-2024-05-25";

  src = fetchFromGitHub {
    owner = "Shark-ML";
    repo = "Shark";
    rev = "16a7cecf1c012ceaa406e3a5af54d1a6a47d5cda";
    hash = "sha256-xwniI2+Kry04zQqlYjMTp60O6YLibFy+Q/2CY0PHpqs=";
  };

  # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/tree/develop/SuperBuild/patches/SHARK?ref_type=heads
  # patch of hdf5 seems to be not needed based on latest master branch of shark as HDF5 has been removed
  # c.f https://github.com/Shark-ML/Shark/commit/221c1f2e8abfffadbf3c5ef7cf324bc6dc9b4315
  patches = [ ./shark-2-ext-num-literals-all.diff ];

  # Remove explicitly setting C++11, because boost::math headers need C++14 since Boost187.
  postPatch = ''
    sed -i '/CXX_STANDARD/d' src/CMakeLists.txt
  '';

  # https://gitlab.orfeo-toolbox.org/orfeotoolbox/otb/-/blob/develop/SuperBuild/CMake/External_shark.cmake?ref_type=heads
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_DOCS=OFF"
    "-DBUILD_TESTING=OFF"
    "-DENABLE_CBLAS=OFF"
  ]
  ++ lib.optionals (!enableOpenMP) [ "-DENABLE_OPENMP=OFF" ];
  buildInputs = [
    boost
    openssl
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Fast, modular, general open-source C++ machine learning library";
    homepage = "https://shark-ml.github.io/Shark/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
