{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-watchdoc";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "romnn";
    repo = "cargo-watchdoc";
    rev = "v${version}";
    sha256 = "sha256-7GBGqEWSy4ncR4o+IdUVXireg+ju6AUBSDyqmKcYUaI=";
  };

  cargoHash = "sha256-P5RlnZyzVcKYgD2TZRgUdafssJRj4ueYA+iLEltV8O0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Generate and serve your crates documentation with hot-reloading during development";
    mainProgram = "cargo-watchdoc";
    homepage = "https://github.com/romnn/cargo-watchdoc";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
}
