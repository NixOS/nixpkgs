{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ceres-solver,
  curl,
  eigen,
  flatbuffers,
  glfw,
  libGL,
  libpcap,
  libpng,
  libtins,
  boost192,
  libzip,
  openssl,
  onetbb,
  zlib,
  zstd,
  gtest,
  runCommandCC,
  nix-update-script,
}:

let
  # FIXME: Drop when default Boost has the ICL/libc++ 22 fix (1.92+).
  # https://github.com/boostorg/icl/pull/54
  libtinsForOuster = libtins.override (
    lib.optionalAttrs stdenv.hostPlatform.isDarwin { boost = boost192; }
  );
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "ouster-sdk";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ouster-lidar";
    repo = "ouster-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tiytOySeS/uOzGPyFK6UjnOq5XaXWy5LK3wuEsZ/WN8=";
  };

  strictDeps = true;

  patches = [ ./cmake-fixes.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # The installed CMake configuration discovers these dependencies for consumers.
  propagatedBuildInputs = [
    ceres-solver
    curl
    eigen
    flatbuffers
    glfw
    libGL
    libpcap
    libpng
    libtinsForOuster
    libzip
    openssl
    onetbb
    zlib
    zstd
  ];
  checkInputs = [ gtest ];

  cmakeFlags = [
    # Ceres 2.2 requires C++17.
    (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17")
    (lib.cmakeFeature "FLATBUFFERS_FLATC_EXECUTABLE" (lib.getExe buildPackages.flatbuffers))
    (lib.cmakeBool "BUILD_SHARED_LIBRARY" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.consumer =
      runCommandCC "ouster-sdk-consumer"
        {
          nativeBuildInputs = [ cmake ];
          buildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          for components in 'Static;Shared;Shared' 'Shared;Static;Static'; do
            cmake -S ${./test} -B build --fresh \
              -DSDK_VERSION=${finalAttrs.version} -DCOMPONENTS="$components"
            cmake --build build
            ${lib.optionalString finalAttrs.doCheck "ctest --test-dir build --output-on-failure"}
          done
          touch "$out"
        '';
    updateScript = nix-update-script { attrPath = "ouster-sdk"; };
  };

  meta = {
    description = "C++ SDK for Ouster lidar sensors";
    homepage = "https://github.com/ouster-lidar/ouster-sdk";
    changelog = "https://github.com/ouster-lidar/ouster-sdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kylemanna ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
