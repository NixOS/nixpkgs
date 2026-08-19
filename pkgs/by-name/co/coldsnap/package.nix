{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "coldsnap";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "coldsnap";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KYP0CQ4t5ytw8vT9kOZsNjl5KY0DzBTiWp2G+oYt1SU=";
  };

  cargoHash = "sha256-clZ1HNABg8dVOcuRI1GmFfyFYZqiB/M1OWBpuiZrg08=";

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
