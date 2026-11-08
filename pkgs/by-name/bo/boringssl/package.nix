{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
  cmake,
  ninja,
  perl,
  gitUpdater,

  withShared ? !stdenv.hostPlatform.isStatic,
}:

# reference: https://boringssl.googlesource.com/boringssl/+/refs/tags/0.20250818.0/BUILDING.md
stdenv.mkDerivation (finalAttrs: {
  pname = "boringssl";
  version = "0.20261105.0";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    tag = finalAttrs.version;
    hash = "sha256-/0V/4R4opWgHOA75IIEAXRFgzHu8QzmmuVrCj/WdJ/w=";
  };

  patches = [
    # Revert https://boringssl-review.googlesource.com/c/boringssl/+/104808 to restore
    # compatibility with the Rust boring-sys crate (as used by dependant packages in nixpkgs).
    # The change moved the SHA wrapper functions to `inline static` header functions for better
    # MSVC compatibility, which in turn breaks Rust FFI.
    (fetchpatch {
      name = "boringssl-revert-inline-sha-functions.patch";
      url = "https://boringssl.googlesource.com/boringssl/+/77cb16a15b27beefab1e1284064a4d99895ef230^!?format=TEXT";
      decode = "base64 -d";
      revert = true;
      hash = "sha256-UMVOxHtif9xlGs/6xLwmbohkkqnc5OPjkYktYlE+TEg=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    perl
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" withShared)
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12 but breaks on darwin (with clang)
      "-Wno-error=stringop-overflow"
      "-Wno-error=array-bounds"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-error=character-conversion"
    ]
  );

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  passthru = {
    updateScript = gitUpdater { };
    isShared = withShared;
  };

  meta = {
    description = "Free TLS/SSL implementation";
    mainProgram = "bssl";
    homepage = "https://boringssl.googlesource.com";
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    license = with lib.licenses; [
      asl20
      isc
      mit
      bsd3
    ];
    platforms = lib.platforms.all;
  };
})
