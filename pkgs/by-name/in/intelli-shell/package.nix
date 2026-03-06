{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  sqlite,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "intelli-shell";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TrT2gMc23m4xZ/fxxHqEkGpq3VBeLfkPXC9H1sSSOaQ=";
  };

  cargoHash = "sha256-usALz3Wj3GyYjHjmEwFvjyDizXKQ66fkZ8Tb7GgT9BA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "extra-features"
  ];

  buildInputs = [
    libgit2
    openssl
    sqlite
    zlib
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Like IntelliSense, but for shells";
    homepage = "https://github.com/lasantosr/intelli-shell";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lasantosr ];
    mainProgram = "intelli-shell";
  };
})
