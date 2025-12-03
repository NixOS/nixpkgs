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
}:

stdenv.mkDerivation rec {
  pname = "cryfs";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "cryfs";
    repo = "cryfs";
    rev = version;
    hash = "sha256-QzxJUh6nD6243x443b0tIb1v2Zs8jRUk8IVarNqs47M=";
  };

  postPatch = ''
    patchShebangs src

    # remove tests that require network access
    substituteInPlace test/cpp-utils/CMakeLists.txt \
      --replace "network/CurlHttpClientTest.cpp" "" \
      --replace "network/FakeHttpClientTest.cpp" ""

    # remove CLI test trying to access /dev/fuse
    substituteInPlace test/cryfs-cli/CMakeLists.txt \
      --replace "CliTest_IntegrityCheck.cpp" "" \
      --replace "CliTest_Setup.cpp" "" \
      --replace "CliTest_WrongEnvironment.cpp" "" \
      --replace "CryfsUnmountTest.cpp" ""

    # downsize large file test as 4.5G is too big for Hydra
    substituteInPlace test/cpp-utils/data/DataTest.cpp \
      --replace "(4.5L*1024*1024*1024)" "(0.5L*1024*1024*1024)"
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
    "-DDEPENDENCY_CONFIG='../cmake-utils/DependenciesFromLocalSystem.cmake'"
    "-DCRYFS_UPDATE_CHECKS:BOOL=FALSE"
    "-DBoost_USE_STATIC_LIBS:BOOL=FALSE" # this option is case sensitive
    "-DBUILD_TESTING:BOOL=${if doCheck then "TRUE" else "FALSE"}"
  ];

  # macFUSE needs to be installed for the test to succeed on Darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck
    export HOME=$(mktemp -d)

    # Skip CMakeFiles directory and tests depending on fuse (does not work well with sandboxing)
    SKIP_IMPURE_TESTS="CMakeFiles|fspp|my-gtest-main"

    for t in $(ls -d test/*/ | grep -E -v "$SKIP_IMPURE_TESTS") ; do
      "./$t$(basename $t)-test"
    done

    runHook postCheck
  '';

  meta = {
    description = "Cryptographic filesystem for the cloud";
    homepage = "https://www.cryfs.org/";
    changelog = "https://github.com/cryfs/cryfs/raw/${version}/ChangeLog.txt";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      peterhoeg
      c0bw3b
      sigmasquadron
    ];
    platforms = lib.platforms.unix;
  };
}
