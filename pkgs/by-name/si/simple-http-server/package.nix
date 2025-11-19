{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "simple-http-server";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = "simple-http-server";
    rev = "v${version}";
    sha256 = "sha256-uTzzQg1UJ+PG2poIKd+LO0T0y7z48ZK0f196zIgeZhs=";
  };

  cargoHash = "sha256-y+pNDg73fAHs9m0uZr6z0HTA/vB3fFM5qukJycuIxnY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    changelog = "https://github.com/TheWaWaR/simple-http-server/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mephistophiles
    ];
    mainProgram = "simple-http-server";
  };
}
