{
  lib,
  stdenv,
  llvmPackages,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nixosTests,
}:

let
  version = "0.2.1";
  target = stdenv.hostPlatform.rust.rustcTargetSpec;
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
in
rustPlatform.buildRustPackage {
  pname = "rustls-libssl";
  inherit version;

  src = fetchFromGitHub {
    owner = "rustls";
    repo = "rustls-openssl-compat";
    rev = "v/${version}";
    hash = "sha256-/QSFrkFVSRBmpXHc80dJFnYwvVYceAFnoCtmAGtnmqo=";
  };

  # NOTE: No longer necessary in the next release.
  sourceRoot = "source/rustls-libssl";

  cargoHash = "sha256-Yyrs2eN4QTGGD7A+VM1YkdsIRUh3laZac3rsJThjTXM=";

  nativeBuildInputs = [
    pkg-config # for openssl-sys
    llvmPackages.lld # build.rs specifies LLD as linker
  ];
  buildInputs = [
    openssl
  ];

  preCheck = ''
    # tests dlopen libcrypto.so.3
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ openssl ]}
  '';

  # rustls-libssl normally wants to be swapped in for libssl, and reuses
  # libcrypto. Here, we accomplish something similar by symlinking most of
  # OpenSSL, replacing only libssl.
  outputs = [
    "out"
    "dev"
  ];
  installPhase = ''
    mkdir -p $out/lib $dev/lib/pkgconfig

    mv target/${target}/release/libssl${libExt} $out/lib/libssl${libExt}.3
    ln -s libssl${libExt}.3 $out/lib/libssl${libExt}

    ln -s ${openssl.out}/lib/libcrypto${libExt}.3 $out/lib/
    ln -s libcrypto${libExt}.3 $out/lib/libcrypto${libExt}

    if [[ -e ${openssl.out}/lib/engines-3 ]]; then
      ln -s ${openssl.out}/lib/engines-3 $out/lib/
    fi
    if [[ -e ${openssl.out}/lib/ossl-modules ]]; then
      ln -s ${openssl.out}/lib/ossl-modules $out/lib/
    fi

    ln -s ${openssl.dev}/include $dev/

    cp ${openssl.dev}/lib/pkgconfig/*.pc $dev/lib/pkgconfig/
    sed -i \
      -e "s|${openssl.out}|$out|g" \
      -e "s|${openssl.dev}|$dev|g" \
      $dev/lib/pkgconfig/*.pc
  '';

  passthru.tests = nixosTests.rustls-libssl;

  meta = {
    description = "Partial reimplementation of the OpenSSL 3 libssl ABI using rustls";
    homepage = "https://github.com/rustls/rustls-openssl-compat";
    changelog = "https://github.com/rustls/rustls-openssl-compat/releases";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      stephank
      cpu
    ];
  };
}
