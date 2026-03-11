{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kaput-cli";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "davidchalifoux";
    repo = "kaput-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N+vdK9DpooPEtXVUNZtmbdjVSpN5ddYggb4FsrvyCwU=";
  };

  cargoHash = "sha256-bz7K3eWv9i50k5nXBb9k8IZ+xPIz4PSomp6K2LDSH78=";

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/davidchalifoux/kaput-cli/releases/tag/v${finalAttrs.version}";
    description = "Unofficial CLI client for Put.io";
    homepage = "https://kaput.sh/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "kaput";
  };
})
