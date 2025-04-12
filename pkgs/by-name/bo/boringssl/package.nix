{
  lib,
  stdenv,
  fetchgit,
  cmake,
  ninja,
  perl,
  buildGoModule,
}:

# reference: https://boringssl.googlesource.com/boringssl/+/2661/BUILDING.md
buildGoModule {
  pname = "boringssl";
  version = "unstable-2024-09-20";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    rev = "718900aeb84c601523e71abbd18fd70c9e2ad884";
    hash = "sha256-TdSObRECiGRQcgz6N2LhKvSi9yRYOZYJdK6MyfJX2Bo=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    perl
  ];

  vendorHash = "sha256-GlhLsPD+yp2LdqsIsfXNEaNKKlc76p0kBCyu4rlEmMg=";
  proxyVendor = true;

  # hack to get both go and cmake configure phase
  # (if we use postConfigure then cmake will loop runHook postConfigure)
  preBuild =
    ''
      cmakeConfigurePhase
    ''
    + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      export GOARCH=$(go env GOHOSTARCH)
    '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      # Needed with GCC 12 but breaks on darwin (with clang)
      "-Wno-error=stringop-overflow"
    ]
  );

  buildPhase = ''
    ninjaBuildPhase
  '';

  # CMAKE_OSX_ARCHITECTURES is set to x86_64 by Nix, but it confuses boringssl on aarch64-linux.
  cmakeFlags = [
    "-GNinja"
  ] ++ lib.optionals (stdenv.hostPlatform.isLinux) [ "-DCMAKE_OSX_ARCHITECTURES=" ];

  installPhase = ''
    mkdir -p $bin/bin $dev $out/lib

    mv tool/bssl $bin/bin

    mv ssl/libssl.a           $out/lib
    mv crypto/libcrypto.a     $out/lib
    mv decrepit/libdecrepit.a $out/lib

    mv ../include $dev
  '';

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  meta = with lib; {
    description = "Free TLS/SSL implementation";
    mainProgram = "bssl";
    homepage = "https://boringssl.googlesource.com";
    maintainers = [ maintainers.thoughtpolice ];
    license = with licenses; [
      openssl
      isc
      mit
      bsd3
    ];
  };
}
