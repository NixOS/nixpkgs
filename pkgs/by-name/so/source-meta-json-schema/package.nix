{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "source-meta-json-schema";
  version = "16.12.0";

  src = fetchFromGitHub {
    owner = "sourcemeta";
    repo = "jsonschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-79onN0W+QnoJW9aj8sS6kJUTliQuR/TK3DCnMBHcMsM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
  ];

  cmakeFlags = [
    # Force use system OPENSSL instead of build (avoid compile the CryptoKit Swift shim on Darwin)
    (lib.cmakeBool "SOURCEMETA_CORE_CRYPTO_USE_SYSTEM_OPENSSL" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Upstream tries to download a clang-tidy from PyPI during configure on Darwin
    # This only affect on Darwin
    (lib.cmakeBool "SOURCEMETA_CORE_CLANG_TIDY" false)
  ];

  meta = {
    homepage = "https://github.com/sourcemeta/jsonschema";
    description = "CLI for working with JSON Schema. Covers formatting, linting, testing, bundling, and more for both local development and CI/CD pipelines ";
    changelog = "https://github.com/sourcemeta/jsonschema/releases";
    license = with lib.licenses; [
      agpl3Plus
    ];
    maintainers = with lib.maintainers; [
      amerino
    ];
    platforms = lib.platforms.all;
  };
})
