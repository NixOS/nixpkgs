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
  apple-sdk_11,
  darwinMinVersionHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edencommon";
  version = "2024.11.18.00";

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "edencommon";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-pVPkH80vowdpwWv/h6ovEk335OeI6/0k0cAFhhFqSDM=";
  };

  patches = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # Test discovery timeout is bizarrely flaky on `x86_64-darwin`
    ./increase-test-discovery-timeout.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs =
    [
      glog
      gflags
      folly
      fb303
      wangle
      fbthrift
      gtest
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_11
      (darwinMinVersionHook "11.0")
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

    (lib.cmakeBool "CMAKE_INSTALL_RPATH_USE_LINK_PATH" true)
  ];

  doCheck = true;

  postPatch = ''
    # The CMake build requires the FBThrift Python support even though
    # it’s not used, presumably because of the relevant code having
    # been moved in from another repository.
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'find_package(FBThrift CONFIG REQUIRED COMPONENTS cpp2 py)' \
        'find_package(FBThrift CONFIG REQUIRED COMPONENTS cpp2)'
  '';

  meta = {
    description = "Shared library for Meta's source control filesystem tools (EdenFS and Watchman)";
    homepage = "https://github.com/facebookexperimental/edencommon";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kylesferrazza ];
  };
})
