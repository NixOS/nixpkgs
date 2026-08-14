{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "coldsnap";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "coldsnap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QQWH8cWBskXOmiZygvkNDyBX4WdsgnA0/ec6/UnmwIA=";
  };

  cargoHash = "sha256-U5MinzKQYTHRXM3WndkMEbvoT9tPwIIB3QxEOwWA3zE=";

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
