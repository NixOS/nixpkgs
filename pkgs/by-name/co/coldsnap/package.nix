{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "coldsnap";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "coldsnap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8+YPKjHi3VURzSOflIa0x4uBkoDMYGFJiFcNJ+8NJ7Q=";
  };

  cargoHash = "sha256-4w79zZcgIulLIArY2ErOHwaWA8g/mA2cSKCzJx4X9vM=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    homepage = "https://github.com/awslabs/coldsnap";
    description = "Command line interface for Amazon EBS snapshots";
    changelog = "https://github.com/awslabs/coldsnap/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "coldsnap";
  };
})
