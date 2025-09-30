{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  perl,
  go,
}:

# reference: https://boringssl.googlesource.com/boringssl/+/refs/tags/0.20250818.0/BUILDING.md
stdenv.mkDerivation (finalAttrs: {
  pname = "boringssl";
  version = "0.20250818.0";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    tag = finalAttrs.version;
    hash = "sha256-lykIlC0tvjtjjS/rQTeX4vK9PgI+A8EnasEC+HYspvg=";
  };

  patches = [
    # Add SECP224R1 for backward compatibility
    ./secp224r1-compat.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    perl
    go
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12 but breaks on darwin (with clang)
      "-Wno-error=stringop-overflow"
    ]
  );

  # CMAKE_OSX_ARCHITECTURES is set to x86_64 by Nix, but it confuses boringssl on aarch64-linux.
  cmakeFlags = [
    "-GNinja"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    "-DCMAKE_OSX_ARCHITECTURES="
  ];

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  meta = {
    description = "Free TLS/SSL implementation";
    mainProgram = "bssl";
    homepage = "https://boringssl.googlesource.com";
    maintainers = [ lib.maintainers.thoughtpolice ];
    license = with lib.licenses; [
      openssl
      isc
      mit
      bsd3
    ];
  };
})
