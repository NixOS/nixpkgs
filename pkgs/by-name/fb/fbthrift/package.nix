{
  lib,
  stdenv,

  fetchFromGitHub,
  fetchpatch,

  cmake,
  ninja,

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
  version = "2025.09.15.00";

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
    hash = "sha256-4u3SbbmSgtvnW3/VH3CfQrEddAlkQuUl9dmnGGKL4mE=";
  };

  patches = [
    # Map `$NIX_BUILD_TOP` to `/build` in the Thrift compiler output to
    # avoid reproducibility issues on Darwin.
    ./scrub-build-directory-from-output.patch

    # Remove a line that breaks the build due to the CMake classic of
    # incorrect path concatenation.
    ./remove-cmake-install-rpath.patch

    ./glog-0.7.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
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
  ];

  propagatedBuildInputs = [
    mvfst
    xxHash
  ];

  cmakeFlags = [
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
    # it. I don’t know, either. It scares me.
    (lib.cmakeFeature "CMAKE_SHARED_LINKER_FLAGS" "-Wl,-undefined,dynamic_lookup")
  ];

  # Fix a typo introduced by the following commit that causes hundreds
  # of pointless rebuilds when installing:
  # <https://github.com/facebook/fbthrift/commit/58038399cefc0c2256ce4ef5444dee37147cbf07>
  postPatch = ''
    substituteInPlace ThriftLibrary.cmake \
      --replace-fail .tcch .tcc
  '';

  # Copied from Homebrew; fixes the following build error:
  #
  #     [ERROR:/nix/var/nix/b/5f3kn8spg6j0z0xlags8va6sq7/source/thrift/lib/thrift/RpcMetadata.thrift:1] unordered_map::at: key not found
  #
  # See:
  #
  # * <https://github.com/facebook/fbthrift/issues/618>
  # * <https://github.com/facebook/fbthrift/issues/607>
  # * <https://github.com/Homebrew/homebrew-core/blob/2135255c78d026541a4106fa98580795740db694/Formula/f/fbthrift.rb#L52-L55>
  #
  # I don’t know why we didn’t need this before the bump to 202
  # to 2025.09.08.00 when we’d been on LLVM 19 for an entire release
  # cycle already, or why we’re getting different errors to those
  # reports, or why this fixes the build anyway. Most of what I do to
  # maintain these packages is copy compilation flags from Homebrew
  # that scare me. I don’t have very much fun with these libraries, to
  # be honest with you.
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-fno-assume-unique-vtables";

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
