{
  cmake,
  fetchFromGitHub,
  gflags,
  gtest,
  lib,
  perl,
  pkgsBuildHost,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ng-log";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "ng-log";
    repo = "ng-log";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SX5DOSeis4J01wuDuI5nOCrhVvlC5IBcFnsVg8D2zes=";
  };

  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
    substituteInPlace src/logging_unittest.cc \
      --replace-warn "/usr/bin/true" "${pkgsBuildHost.coreutils}/bin/true"
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    # glog's custom FindUnwind.cmake module detects LLVM's unwind in case
    # stdenv.cc is clang. But the module doesn't get installed, causing
    # consumers of the CMake config file to fail at the configuration step.
    # Explicitly disabling unwind support sidesteps the issue.
    "-DWITH_UNWIND=OFF"
  ];

  env.GTEST_FILTER =
    let
      filteredTests =
        lib.optionals stdenv.hostPlatform.isMusl [
          "Symbolize.SymbolizeStackConsumption"
          "Symbolize.SymbolizeWithDemanglingStackConsumption"
        ]
        ++ lib.optionals stdenv.hostPlatform.isStatic [
          "LogBacktraceAt.DoesBacktraceAtRightLineWhenEnabled"
        ]
        ++ lib.optionals stdenv.cc.isClang [
          # Clang optimizes an expected allocation away.
          # See https://github.com/google/glog/issues/937
          "DeathNoAllocNewHook.logging"
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          "LogBacktraceAt.DoesBacktraceAtRightLineWhenEnabled"
        ];
    in
    "-${builtins.concatStringsSep ":" filteredTests}";

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  propagatedBuildInputs = [ gflags ];

  doCheck = true;

  # There are some non-thread safe tests that can fail
  enableParallelChecking = false;

  nativeCheckInputs = [ perl ];

  checkPhase =
    let
      excludedTests =
        lib.optionals stdenv.hostPlatform.isDarwin [
          "mock-log"
        ]
        ++ [
          "logging" # works around segfaults for now
        ];
      excludedTestsRegex = lib.optionalString (
        excludedTests != [ ]
      ) "(${lib.concatStringsSep "|" excludedTests})";
    in
    ''
      runHook preCheck
      ctest -E "${excludedTestsRegex}" --output-on-failure
      runHook postCheck
    '';

  outputs = [
    "dev"
    "out"
  ];

  meta = {
    description = "C++14 library for application-level logging";
    downloadPage = "https://github.com/ng-log/ng-log";
    homepage = "https://ng-log.github.io/ng-log/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ superherointj ];
  };
})
