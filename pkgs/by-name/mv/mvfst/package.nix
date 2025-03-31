{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,
  removeReferencesTo,

  folly,
  gflags,
  glog,

  fizz,

  gtest,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mvfst";
  version = "2025.02.10.00";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "mvfst";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IsBydt1T33yedlaoyKl43fB7Dsuu4RPPiJuUtwZIUGg=";
  };

  patches = [
    ./glog-0.7.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    removeReferencesTo
  ];

  buildInputs = [
    folly
    gflags
    glog
  ];

  propagatedBuildInputs = [
    fizz
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

      (lib.cmakeBool "CMAKE_INSTALL_RPATH_USE_LINK_PATH" true)

      (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)

      (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (placeholder "dev"))
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Homebrew sets this, and the shared library build fails without
      # it. I don‘t know, either. It scares me.
      (lib.cmakeFeature "CMAKE_SHARED_LINKER_FLAGS" "-Wl,-undefined,dynamic_lookup")
    ];

  __darwinAllowLocalNetworking = true;

  doCheck = true;

  postPatch = ''
    # Make sure the libraries the `tperf` binary uses are installed.
    printf 'install(TARGETS mvfst_test_utils)\n' >> quic/common/test/CMakeLists.txt
    printf 'install(TARGETS mvfst_dsr_backend)\n' >> quic/dsr/CMakeLists.txt
  '';

  checkPhase = ''
    runHook preCheck

    ctest -j $NIX_BUILD_CORES --output-on-failure ${
      lib.optionalString stdenv.hostPlatform.isLinux (
        lib.escapeShellArgs [
          "--exclude-regex"
          (lib.concatMapStringsSep "|" (test: "^${lib.escapeRegex test}$") [
            "*/QuicClientTransportIntegrationTest.NetworkTest/*"
            "*/QuicClientTransportIntegrationTest.FlowControlLimitedTest/*"
            "*/QuicClientTransportIntegrationTest.NetworkTestConnected/*"
            "*/QuicClientTransportIntegrationTest.SetTransportSettingsAfterStart/*"
            "*/QuicClientTransportIntegrationTest.TestZeroRttSuccess/*"
            "*/QuicClientTransportIntegrationTest.ZeroRttRetryPacketTest/*"
            "*/QuicClientTransportIntegrationTest.NewTokenReceived/*"
            "*/QuicClientTransportIntegrationTest.UseNewTokenThenReceiveRetryToken/*"
            "*/QuicClientTransportIntegrationTest.TestZeroRttRejection/*"
            "*/QuicClientTransportIntegrationTest.TestZeroRttNotAttempted/*"
            "*/QuicClientTransportIntegrationTest.TestZeroRttInvalidAppParams/*"
            "*/QuicClientTransportIntegrationTest.ChangeEventBase/*"
            "*/QuicClientTransportIntegrationTest.ResetClient/*"
            "*/QuicClientTransportIntegrationTest.TestStatelessResetToken/*"
          ])
        ]
      )
    }

    runHook postCheck
  '';

  postFixup = ''
    # Sanitize header paths to avoid runtime dependencies leaking in
    # through `__FILE__`.
    (
      shopt -s globstar
      for header in "$dev/include"/**/*.h; do
        sed -i "1i#line 1 \"$header\"" "$header"
        remove-references-to -t "$dev" "$header"
      done
    )

    # TODO: Do this in `gtest` rather than downstream.
    remove-references-to -t ${gtest.dev} $out/lib/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the QUIC transport protocol";
    homepage = "https://github.com/facebook/mvfst";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      ris
      emily
      techknowlogick
    ];
  };
})
