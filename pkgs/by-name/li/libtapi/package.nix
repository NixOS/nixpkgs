{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  zlib,
}:

let
  # libtapi is only supported building against Apple’s LLVM fork pinned to a specific revision.
  # It can’t be built against upstream LLVM because it uses APIs that are specific to Apple’s fork.
  # See: https://github.com/apple-oss-distributions/tapi/blob/main/Readme.md

  # Apple’s LLVM fork uses its own versioning scheme.
  # See: https://en.wikipedia.org/wiki/Xcode#Toolchain_versions
  # Note: Can’t use a sparse checkout because the Darwin stdenv bootstrap can’t depend on fetchgit.
  appleLlvm = {
    version = "16.0.0"; # As reported by upstream’s `tapi --version`.
    rev = "3602748d4ec9947f0d1493511a8c34410909506e"; # Per the TAPI repo.
    hash = "sha256-7o/JY/tcu4AeXCa7xhfjbuuV3/Cbf89AdoZOKrciJk0=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libtapi";
  version = "1600.0.11.8";

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  srcs = [
    (fetchFromGitHub {
      name = "tapi-src";
      owner = "apple-oss-distributions";
      repo = "tapi";
      tag = "tapi-${finalAttrs.version}";
      hash = "sha256-87AQZrCmZHv3lbfUnw0j17H4cP+GN5g0D6zhdT4P56Y=";
    })
    # libtapi can’t avoid pulling the whole repo even though it needs only a couple of folders because
    # `fetchgit` can’t be used in the Darwin bootstrap.
    (fetchFromGitHub {
      name = "apple-llvm-src";
      owner = "apple";
      repo = "llvm-project";
      inherit (appleLlvm) rev hash;
    })
  ];

  patches = [
    # Older versions of ld64 may not support `-no_exported_symbols`, so use it only
    # when the linker supports it.
    # Note: This can be dropped once the bootstrap tools are updated after the ld64 update.
    ./0001-Check-for-no_exported_symbols-linker-support.patch
    # Fix build on Linux. GCC is more picky than clang about the field order.
    ./0003-Match-designator-order-with-declaration-order.patch
  ];

  postPatch = ''
    # Enable building on non-Darwin platforms
    substituteInPlace tapi/CMakeLists.txt \
      --replace-fail 'message(FATAL_ERROR "Unsupported configuration.")' ""

    # Remove the client limitation on linking to libtapi.dylib.
    substituteInPlace tapi/tools/libtapi/CMakeLists.txt \
      --replace-fail '-allowable_client ld' ""
    # Replace hard-coded installation paths with standard ones.
    declare -A installdirs=(
      [bin]=BINDIR
      [include]=INCLUDEDIR
      [lib]=LIBDIR
      [local/bin]=BINDIR
      [local/share/man]=MANDIR
      [share/man]=MANDIR
    )
    for dir in "''${!installdirs[@]}"; do
      cmakevar=CMAKE_INSTALL_''${installdirs[$dir]}
      for cmakelist in $(grep -rl "DESTINATION $dir" tapi); do
        substituteInPlace "$cmakelist" \
          --replace-fail "DESTINATION $dir" "DESTINATION \''${$cmakevar}"
      done
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Remove Darwin-specific versioning flags.
    substituteInPlace tapi/tools/libtapi/CMakeLists.txt \
        --replace-fail '-current_version ''${DYLIB_VERSION} -compatibility_version 1' ""
  '';

  preUnpack = ''
    mkdir source
  '';

  sourceRoot = "source";

  postUnpack = ''
    chmod -R u+w apple-llvm-src tapi-src
    mv apple-llvm-src/{clang,cmake,llvm,utils} source
    mv tapi-src source/tapi
  '';

  strictDeps = true;

  buildInputs = [ zlib ]; # Upstream links against zlib in their distribution.

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  cmakeDir = "../llvm";

  cmakeFlags = [
    (lib.cmakeFeature "LLVM_ENABLE_PROJECTS" "clang;tapi")
    (lib.cmakeFeature "LLVM_EXTERNAL_PROJECTS" "tapi")
    (lib.cmakeBool "TAPI_INCLUDE_DOCS" true)
    # Matches the version string format reported by upstream `tapi`.
    (lib.cmakeFeature "TAPI_REPOSITORY_STRING" "tapi-${finalAttrs.version}")
    (lib.cmakeFeature "TAPI_FULL_VERSION" appleLlvm.version)
    # Match the versioning used by Apple’s LLVM fork (primarily used for .so versioning).
    (lib.cmakeFeature "LLVM_VERSION_MAJOR" (lib.versions.major appleLlvm.version))
    (lib.cmakeFeature "LLVM_VERSION_MINOR" (lib.versions.minor appleLlvm.version))
    (lib.cmakeFeature "LLVM_VERSION_PATCH" (lib.versions.patch appleLlvm.version))
    (lib.cmakeFeature "LLVM_VERSION_SUFFIX" "")
    # Upstream `tapi` does not link against ncurses. Disable it explicitly to make sure
    # it is not detected incorrectly from the bootstrap tools tarball.
    (lib.cmakeBool "LLVM_ENABLE_TERMINFO" false)
    # Disabling the benchmarks avoids a failure during the configure phase because
    # the sparse checkout does not include the benchmarks.
    (lib.cmakeBool "LLVM_INCLUDE_BENCHMARKS" false)
    # tapi’s tests expect to target macOS 13.0 and build both x86_64 and universal
    # binaries regardless of the host platform.
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
    (lib.cmakeBool "TAPI_INCLUDE_TESTS" false)
  ];

  ninjaFlags = [
    "libtapi"
    "tapi-sdkdb"
    "tapi"
  ];

  installTargets = [
    "install-libtapi"
    "install-tapi-docs"
    "install-tapi-headers"
    "install-tapi-sdkdb"
    "install-tapi"
  ];

  postInstall = ''
    # The man page is installed for these, but they’re not included in the source release.
    rm $bin/share/man/man1/tapi-analyze.1 $bin/share/man/man1/tapi-api-verify.1
  '';

  meta = {
    description = "Replaces the Mach-O Dynamic Library Stub files in Apple's SDKs to reduce the size";
    homepage = "https://github.com/apple-oss-distributions/tapi/";
    license = lib.licenses.ncsa;
    mainProgram = "tapi";
    maintainers = with lib.maintainers; [
      reckenrode
    ];
    platforms = lib.platforms.unix;
  };
})
