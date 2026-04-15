{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  perl,
  gitUpdater,
}:

# reference: https://boringssl.googlesource.com/boringssl/+/refs/tags/0.20250818.0/BUILDING.md
stdenv.mkDerivation (finalAttrs: {
  pname = "boringssl";
  version = "0.20260327.0";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    tag = finalAttrs.version;
    hash = "sha256-OMRJ4K9ETCitdEGmCYlBH8R7RjMkYno1hAX11bF8KH4=";
  };

  patches = [
    # Add SECP224R1 for backward compatibility
    ./secp224r1-compat.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    perl
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

  passthru.updateScript = gitUpdater { };

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
