{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  boost,
  curl,
  fuse,
  gtest,
  openssl,
  range-v3,
  spdlog,
  llvmPackages,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cryfs";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "cryfs";
    repo = "cryfs";
    tag = finalAttrs.version;
    hash = "sha256-DbXZxPACisAcdaqaqRiBK2Su/Wp6E9Mh+w62EkJrpYA=";
  };

  postPatch = ''
    patchShebangs src/
  ''
  # Set Boost_USE_STATIC_LIBS via CMake command line. (see cmakeFlags below)
  + ''
    substituteInPlace cmake-utils/Dependencies.cmake \
      --replace-fail "set(Boost_USE_STATIC_LIBS OFF)" ""
  ''
  # Downsize large file test as 4.5G is too big for Hydra.
  + ''
    substituteInPlace test/cpp-utils/data/DataTest.cpp \
      --replace-fail "(4.5L*1024*1024*1024)" "(0.5L*1024*1024*1024)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  strictDeps = true;

  buildInputs = [
    boost
    curl
    fuse
    gtest
    openssl
    range-v3
    spdlog
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    (lib.cmakeFeature "DEPENDENCY_CONFIG" "../cmake-utils/DependenciesFromLocalSystem.cmake")
    (lib.cmakeBool "CRYFS_UPDATE_CHECKS" false)
    (lib.cmakeBool "Boost_USE_STATIC_LIBS" stdenv.hostPlatform.isStatic) # This option is case sensitive.
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  # macFUSE needs to be installed for the tests to succeed on Darwin.
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkPhase =
    let
      runTest =
        {
          path,
          filter ? null,
        }:
        "command ./${path}${lib.optionalString (!isNull filter) " '--gtest_filter=${filter}'"}";
    in
    ''
      runHook preCheck

      pushd test/
    ''
    # See the test runner at https://github.com/cryfs/cryfs/blob/1.0.3/.github/workflows/actions/run_tests/action.yaml.
    + (lib.concatLines [
      (runTest {
        path = "gitversion/gitversion-test";
      })
      (runTest {
        path = "cpp-utils/cpp-utils-test";
        filter =
          if stdenv.hostPlatform.isStatic then "*-BacktraceTest.*:*.AssertMessageContainsBacktrace" else null;
      })
      (runTest {
        path = "parallelaccessstore/parallelaccessstore-test";
      })
      (runTest {
        path = "blockstore/blockstore-test";
      })
      (runTest {
        path = "blobstore/blobstore-test";
      })
      (runTest {
        path = "cryfs/cryfs-test";
      })
      # Skip tests trying to access /dev/fuse inside the build sandbox.
      (runTest {
        path = "fspp/fspp-test";
        filter = ""; # Skip all tests.
      })
      (runTest {
        path = "cryfs-cli/cryfs-cli-test";
        filter = "*-CliTest.WorksWithCommasInBasedir:CliTest_IntegrityCheck.*:CliTest_Setup.*:CliTest_Unmount.*:RunningInForeground*";
      })
    ])
    + ''
      popd

      runHook postCheck
    '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Cryptographic filesystem for the cloud";
    homepage = "https://www.cryfs.org/";
    changelog = "https://github.com/cryfs/cryfs/raw/${finalAttrs.version}/ChangeLog.txt";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      peterhoeg
      sigmasquadron
    ];
    platforms = lib.systems.inspect.patterns.isUnix;
  };
})
