{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix,
  # Crypto backends
  openssl,
  aws-lc,
  libressl,
  boringssl,
  # Backend selection: "openssl" (default), "aws-lc", "libressl", "boringssl"
  cryptoBackend ? "openssl",
}:

let
  cryptoLib =
    {
      openssl = openssl;
      aws-lc = aws-lc;
      libressl = libressl;
      boringssl = boringssl;
    }
    .${cryptoBackend}
      or (throw "Unknown crypto backend: ${cryptoBackend}. Valid options: openssl, aws-lc, libressl, boringssl");

  # Feature notes per backend:
  # - aws-lc: PQ key exchange, FIPS support (recommended for performance/security)
  # - openssl: Widely compatible (1.0.2, 1.1.1, 3.0.x)
  # - libressl: OpenBSD fork, security focused
  # - boringssl: No OCSP, no FIPS support
in
stdenv.mkDerivation (finalAttrs: {
  pname = "s2n-tls";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "s2n-tls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oqWTcUGutEn5cOggiY1yPUlVWiHYKjnwBCCrEeWYn0A=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [ cryptoLib ]; # s2n-config has find_dependency(LibCrypto).

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DUNSAFE_TREAT_WARNINGS_AS_ERRORS=OFF" # disable -Werror
    "-DCMAKE_PREFIX_PATH=${cryptoLib}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMips64 [
    # See https://github.com/aws/s2n-tls/issues/1592 and https://github.com/aws/s2n-tls/pull/1609
    "-DS2N_NO_PQ=ON"
  ]
  ++ lib.optionals (cryptoBackend != "aws-lc") [
    # PQ crypto only supported with aws-lc
    "-DS2N_NO_PQ=ON"
  ];

  propagatedBuildInputs = [ cryptoLib ]; # s2n-config has find_dependency(LibCrypto).

  # boringssl is static-only in nixpkgs and contains C++ code (e.g. operator
  # new with std::nothrow_t). Linking libs2n-tls.so with the C driver leaves
  # the C++ runtime unresolved; downstream executables then fail with
  # "undefined reference to std::nothrow_t" etc. Pull libstdc++/libc++ into
  # s2n-tls directly so it arrives via DT_NEEDED and consumers don't notice.
  env.NIX_LDFLAGS = lib.optionalString (cryptoBackend == "boringssl") (
    if stdenv.hostPlatform.isDarwin then "-lc++" else "-lstdc++"
  );

  postInstall = ''
    # Glob for 'shared' or 'static' subdir
    for f in $out/lib/s2n/cmake/*/s2n-targets.cmake; do
      substituteInPlace "$f" \
        --replace-fail 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES ""'
    done
  '';

  passthru = {
    tests = {
      inherit nix;
    };
    inherit cryptoBackend cryptoLib;
  };

  meta = {
    description = "C99 implementation of the TLS/SSL protocols";
    longDescription = ''
      s2n-tls is a C99 implementation of the TLS/SSL protocols from AWS.
      Built with ${cryptoBackend} as the crypto backend.
    '';
    homepage = "https://github.com/aws/s2n-tls";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
