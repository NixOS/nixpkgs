{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,
  removeReferencesTo,

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
  version = "2025.01.06.00";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "facebookexperimental";
    repo = "edencommon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9JCyXFWglnIuDw5jSSqcnuMfQ2JXMdNwFVyyBccjoag=";
  };

  patches =
    [
      ./glog-0.7.patch
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # Test discovery timeout is bizarrely flaky on `x86_64-darwin`
      ./increase-test-discovery-timeout.patch
    ];

  nativeBuildInputs = [
    cmake
    ninja
    removeReferencesTo
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
