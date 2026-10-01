{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,

  glog,
  gflags,
  folly,
  fb303,
  wangle,
  fbthrift,
  gtest,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edencommon";
  version = "2026.07.27.00";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "edencommon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RcLdBurFB4Zk479EHeGZHdNKvSMO1M54HDbxHVEFa7Y=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    glog
    gflags
    folly
    fb303
    wangle
    fbthrift
    gtest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

    (lib.cmakeBool "CMAKE_INSTALL_RPATH_USE_LINK_PATH" true)

    (lib.cmakeFeature "INCLUDE_INSTALL_DIR" "${placeholder "dev"}/include")
    (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "out"}/lib")
    (lib.cmakeFeature "CMAKE_INSTALL_DIR" "${placeholder "dev"}/lib/cmake/edencommon")
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    # Skip flaky test
    ctest -j $NIX_BUILD_CORES --output-on-failure ${
      lib.escapeShellArgs [
        "--exclude-regex"
        (lib.concatMapStringsSep "|" (test: "^${lib.escapeRegex test}$") [
          "ProcessInfoCache.addFromMultipleThreads"
        ])
      ]
    }

    runHook postCheck
  '';

  postPatch = ''
    # The CMake build requires the FBThrift Python support even though
    # it’s not used, presumably because of the relevant code having
    # been moved in from another repository.
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'find_package(FBThrift CONFIG REQUIRED COMPONENTS cpp2 py)' \
        'find_package(FBThrift CONFIG REQUIRED COMPONENTS cpp2)'

    # this header was missing. this is likely a consequence of fmt v12.2.0
    # changing the definition of its fmt/core.h header, which is included in
    # the same file.
    sed -e '1i #include <string>' -i eden/common/utils/String.h
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Shared library for Meta's source control filesystem tools (EdenFS and Watchman)";
    homepage = "https://github.com/facebookexperimental/edencommon";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      kylesferrazza
      emily
      techknowlogick
    ];
  };
})
