{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  perl,
}:

# reference: https://boringssl.googlesource.com/boringssl/+/2661/BUILDING.md
stdenv.mkDerivation (finalAttrs: {
  pname = "boringssl";
  version = "0.20250818.0";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    tag = finalAttrs.version;
    hash = "sha256-lykIlC0tvjtjjS/rQTeX4vK9PgI+A8EnasEC+HYspvg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    perl
  ];

  # hack to get both go and cmake configure phase
  # (if we use postConfigure then cmake will loop runHook postConfigure)
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
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [ "-DCMAKE_OSX_ARCHITECTURES=" ];

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  meta = with lib; {
    description = "Free TLS/SSL implementation";
    mainProgram = "bssl";
    homepage = "https://boringssl.googlesource.com";
    maintainers = [
      maintainers.thoughtpolice
      maintainers.theoparis
    ];
    license = with licenses; [
      asl20
      isc
      mit
      bsd3
    ];
  };
})
