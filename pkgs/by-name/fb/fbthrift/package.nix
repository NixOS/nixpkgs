{
  lib,
  stdenv,

  fetchFromGitHub,

  cmake,
  ninja,
  removeReferencesTo,

  openssl,
  gflags,
  glog,
  folly,
  fizz,
  wangle,
  zlib,
  zstd,
  xxHash,

  mvfst,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fbthrift";
  version = "2025.02.10.00";

  outputs = [
    # Trying to split this up further into `bin`, `out`, and `dev`
    # causes issues with circular references due to the installed CMake
    # files referencing the path to the compiler.
    "out"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "fbthrift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-130BHYUFDo11T9bI7cQ7Y+lTnFSr3WNgJ7IA+3BE9+g=";
  };

  patches = [
    # Remove a line that breaks the build due to the CMake classic of
    # incorrect path concatenation.
    ./remove-cmake-install-rpath.patch

    ./glog-0.7.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    removeReferencesTo
  ];

  buildInputs = [
    openssl
    gflags
    glog
    folly
    fizz
    wangle
    zlib
    zstd
    xxHash
  ];

  propagatedBuildInputs = [
    mvfst
  ];

  cmakeFlags =
    [
      (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))

      (lib.cmakeBool "thriftpy" false)

      # TODO: Can’t figure out where the C++ tests are wired up in the
      # CMake build, if anywhere, and this requires Python.
      #(lib.cmakeBool "enable_tests" finalAttrs.finalPackage.doCheck)

      (lib.cmakeFeature "BIN_INSTALL_DIR" "${placeholder "out"}/bin")
      (lib.cmakeFeature "INCLUDE_INSTALL_DIR" "${placeholder "out"}/include")
      (lib.cmakeFeature "LIB_INSTALL_DIR" "${placeholder "lib"}/lib")
      (lib.cmakeFeature "CMAKE_INSTALL_DIR" "${placeholder "out"}/lib/cmake/fbthrift")
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Homebrew sets this, and the shared library build fails without
      # it. I don‘t know, either. It scares me.
      (lib.cmakeFeature "CMAKE_SHARED_LINKER_FLAGS" "-Wl,-undefined,dynamic_lookup")
    ];

  postFixup = ''
    # Sanitize header paths to avoid runtime dependencies leaking in
    # through `__FILE__`.
    (
      shopt -s globstar
      for header in "$out/include"/**/*.h; do
        sed -i "1i#line 1 \"$header\"" "$header"
        remove-references-to -t "$out" "$header"
      done
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Facebook's branch of Apache Thrift";
    mainProgram = "thrift1";
    homepage = "https://github.com/facebook/fbthrift";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pierreis
      kylesferrazza
      emily
      techknowlogick
    ];
  };
})
