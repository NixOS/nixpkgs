{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-duplicates";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Keruspe";
    repo = "cargo-duplicates";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JzS1+BHSCEcZM5MokbQsck/AGJ7EeSwbzjNz0uLQsgE=";
  };

  cargoHash = "sha256-58H6wFToCgW+J7QYXb6W6BiCFUVIG8MmxgZtWnPNkrI=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ];

  meta = {
    description = "Cargo subcommand for displaying when different versions of a same dependency are pulled in";
    mainProgram = "cargo-duplicates";
    homepage = "https://github.com/Keruspe/cargo-duplicates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
