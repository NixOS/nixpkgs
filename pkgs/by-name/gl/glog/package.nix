{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gflags,
  gtest,
  perl,
  pkgsBuildHost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glog";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+nwWP6VBmhgU7GCPSEGUzvUSCc48wXME181WpJ5ABP4=";
  };

  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
    substituteInPlace src/logging_unittest.cc \
      --replace-warn "/usr/bin/true" "${pkgsBuildHost.coreutils}/bin/true"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ gtest ];

  propagatedBuildInputs = [ gflags ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    # glog's custom FindUnwind.cmake module detects LLVM's unwind in case
    # stdenv.cc is clang. But the module doesn't get installed, causing
    # consumers of the CMake config file to fail at the configuration step.
    # Explicitly disabling unwind support sidesteps the issue.
    "-DWITH_UNWIND=OFF"
  ];

  doCheck = true;

  # There are some non-thread safe tests that can fail
  enableParallelChecking = false;
  nativeCheckInputs = [ perl ];

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

  meta = with lib; {
    homepage = "https://github.com/google/glog";
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
    maintainers = with maintainers; [
      nh2
      r-burns
    ];
  };
})
