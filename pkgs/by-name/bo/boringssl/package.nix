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
buildGoModule (finalAttrs: {
  pname = "boringssl";
  version = "0.20250415.0";

  src = fetchgit {
    url = "https://boringssl.googlesource.com/boringssl";
    tag = finalAttrs.version;
    hash = "sha256-/GZutq286F3gwQ3UhYjuR20bXzbqo4FxiC7E0yt5T60=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    perl
  ];

  vendorHash = "sha256-IXmnoCYLoiQ/XL2wjksRFv5Kwsje0VNkcupgGxG6rSY=";
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
    runHook preInstall

    mkdir -p $bin/bin $dev $out/lib

    mv tool/bssl $bin/bin

    mv ssl/libssl.a           $out/lib
    mv crypto/libcrypto.a     $out/lib
    mv decrepit/libdecrepit.a $out/lib

    mv ../include $dev

    runHook postInstall
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
