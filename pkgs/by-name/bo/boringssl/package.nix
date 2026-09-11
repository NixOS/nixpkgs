{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  perl,
  gitUpdater,

  withShared ? !stdenv.hostPlatform.isStatic,
}:

# reference: https://boringssl.googlesource.com/boringssl/+/refs/tags/0.20250818.0/BUILDING.md
stdenv.mkDerivation (finalAttrs: {
  pname = "boringssl";
  version = "0.20260803.0";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    tag = finalAttrs.version;
    hash = "sha256-GmaXG6I2euA+Q7naO2Oxu+P4mK37RbgwW5iM7ync6Gg=";
  };

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
      thoughtpolice
      theoparis
      niklaskorz
    ];
    license = with lib.licenses; [
      asl20
      isc
      mit
      bsd3
    ];
  };
})
