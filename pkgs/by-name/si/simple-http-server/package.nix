{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
  withTls ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "simple-http-server";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = "simple-http-server";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JG9dqc8E8rUjSG3pBypamjNqFpM87r7cK+zP+PSyMCQ=";
  };

  cargoHash = "sha256-3DelxN2oTFZzoSke7uLbSKYJnF2Bq4MWDvfnKTIsbGk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optional withTls openssl;
  buildFeatures = lib.optional withTls "tls";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    changelog = "https://github.com/TheWaWaR/simple-http-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mephistophiles
      progrm_jarvis
    ];
    mainProgram = "simple-http-server";
  };
})
