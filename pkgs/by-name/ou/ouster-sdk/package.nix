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
  libzip,
  openssl,
  onetbb,
  zlib,
  zstd,
  gtest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "ouster-sdk";
  version = "1.0.1";

  outputs = [
    "out"
    "dev"
    "static"
  ];

  outputChecks.out.disallowedRequisites = [
    "dev"
    "static"
  ];

  src = fetchFromGitHub {
    owner = "ouster-lidar";
    repo = "ouster-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tiytOySeS/uOzGPyFK6UjnOq5XaXWy5LK3wuEsZ/WN8=";
  };

  strictDeps = true;

  patches = [
    # Include the public perception stub in shared builds on Unix too.
    # Discover the OpenGL target exported by the static visualizer library.
    # Keep repeated Shared and Static component discovery idempotent.
    ./cmake-fixes.patch
  ];

  nativeBuildInputs = [
    cmake
    flatbuffers
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
    libtins
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

  postFixup = ''
    moveToOutput "lib/*.a" "$static"
    substituteInPlace "$dev"/lib/cmake/OusterSDK/OusterSDKTargets*.cmake \
      --replace-quiet "$"'{_IMPORT_PREFIX}/lib/' "$static/lib/" \
      --replace-quiet "$out/lib/" "$static/lib/"
  '';

  passthru = {
    tests.consumer = stdenv.mkDerivation {
      name = "ouster-sdk-consumer-test";
      src = ./test;
      nativeBuildInputs = [ cmake ];
      buildInputs = [ finalAttrs.finalPackage ];
      cmakeFlags = [ (lib.cmakeFeature "OUSTER_SDK_VERSION" finalAttrs.version) ];
      doCheck = true;
      postCheck = ''
        sharedConfig="$TMPDIR/shared-config"
        mkdir "$sharedConfig"
        cp ${lib.getDev finalAttrs.finalPackage}/lib/cmake/OusterSDK/*.cmake "$sharedConfig"
        rm "$sharedConfig"/OusterSDKTargets*.cmake
        cmake -S "$src" -B shared-only \
          -DSHARED_ONLY=ON \
          -DOUSTER_SDK_VERSION=${finalAttrs.version} \
          -DOusterSDK_DIR="$sharedConfig"
        cmake --build shared-only --parallel "$NIX_BUILD_CORES"
        ctest --test-dir shared-only --output-on-failure
      '';
      installPhase = ''
        runHook preInstall
        touch "$out"
        runHook postInstall
      '';
    };
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
