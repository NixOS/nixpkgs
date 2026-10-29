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
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s5gbpobCxTtrlEwe1AAidoM8p/1yU/mnZ7JKUu4A0Qk=";
  };

  cargoHash = "sha256-D17BqWiUECM9DeOu/I3xN+aopmw8lZBbUyAIygse0kA=";

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
