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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cryfs";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "cryfs";
    repo = "cryfs";
    rev = finalAttrs.version;
    hash = "sha256-bBe//AjA9QmdSDlb0xiOboE5F4g6LJ03cHQZpfOk+Y4=";
  };

  postPatch = ''
    patchShebangs src

    # set Boost_USE_STATIC_LIBS via CMake command line (see cmakeFlags)
    substituteInPlace cmake-utils/Dependencies.cmake \
      --replace-fail "set(Boost_USE_STATIC_LIBS OFF)" ""

    # downsize large file test as 4.5G is too big for Hydra
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
    (lib.cmakeBool "Boost_USE_STATIC_LIBS" stdenv.hostPlatform.isStatic) # this option is case sensitive
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  # macFUSE needs to be installed for the test to succeed on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkPhase = ''
    runHook preCheck

    # https://github.com/cryfs/cryfs/blob/1.0.3/.github/workflows/actions/run_tests/action.yaml
    cd test/
    set -x
    ./gitversion/gitversion-test
    ./cpp-utils/cpp-utils-test ${lib.optionalString stdenv.hostPlatform.isStatic "'--gtest_filter=*-BacktraceTest.*:*.AssertMessageContainsBacktrace'"}
    ./parallelaccessstore/parallelaccessstore-test
    ./blockstore/blockstore-test
    ./blobstore/blobstore-test
    ./cryfs/cryfs-test
    # skip tests trying to access /dev/fuse
    ./fspp/fspp-test '--gtest_filter=' # skip all
    ./cryfs-cli/cryfs-cli-test '--gtest_filter=*-CliTest.WorksWithCommasInBasedir:CliTest_IntegrityCheck.*:CliTest_Setup.*:CliTest_Unmount.*:RunningInForeground*'
    set +x
    cd -

    runHook postCheck
  '';

  meta = {
    description = "Cryptographic filesystem for the cloud";
    homepage = "https://www.cryfs.org/";
    changelog = "https://github.com/cryfs/cryfs/raw/${finalAttrs.version}/ChangeLog.txt";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      peterhoeg
      sigmasquadron
    ];
    platforms = lib.platforms.unix;
  };
})
