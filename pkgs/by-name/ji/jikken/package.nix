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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "jikkenio";
    repo = "jikken";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8A9b9Ms/unv+qQRd5jiTV/6SJa6ZYLsE0fK97ohacPI=";
  };

  cargoHash = "sha256-nwFTKol5phXFuDzAcnPoFq8UrrqMDE6NuitpXE5qJwU=";

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
