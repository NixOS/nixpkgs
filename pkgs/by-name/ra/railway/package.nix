{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "railway";
  version = "4.36.1";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PYTkYCggHvLPWy+YcnLJLdznxglBn4hSvMENAFs5GH0=";
  };

  cargoHash = "sha256-ZxU/vq/A6O4ziEfLUSeQlwQLZEMnE1wnpyfyrYvOs5M=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = 1;

  meta = {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Crafter
      techknowlogick
    ];
  };
})
