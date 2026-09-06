{
  apple-sdk_15,
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jikken";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "jikkenio";
    repo = "jikken";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j9Rmo9szQtTZU2O6YRhkjMr5pV8tflUdr5hgXqYQxjc=";
  };

  cargoHash = "sha256-V7Qy+0l3UvW5bM2OV3haGVg3KWDaEiEMvg4wvpwwuk4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^(v\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Powerful, source control friendly REST API testing toolkit";
    homepage = "https://jikken.io/";
    changelog = "https://github.com/jikkenio/jikken/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
    mainProgram = "jk";
  };
})
