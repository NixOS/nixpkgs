{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "circom";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "iden3";
    repo = "circom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-om9rLaQAimbBQx3kl+OlRpewqYcEEu0MiudaFfSDI2A=";
  };

  cargoHash = "sha256-h7jdcSXQ0qcsWcG7d0nb2iQCsQmXFj9hO5NAptwVe28=";
  doCheck = false;

  meta = {
    description = "zkSnark circuit compiler";
    mainProgram = "circom";
    homepage = "https://github.com/iden3/circom";
    changelog = "https://github.com/iden3/circom/blob/${finalAttrs.src.rev}/RELEASES.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ raitobezarius ];
  };
})
