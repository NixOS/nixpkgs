{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dalfox";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "dalfox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NhYoxsV1xxCbteI691ld6rHdlBGyJr6yn0ZJvDHEt8w=";
  };

  cargoHash = "sha256-huOPIV2sblLQ5P5dO+qrBDl5F7LokTieyecjhjmhmP0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  # Many unit tests perform live HTTP requests / OOB interactsh lookups and
  # fail in the sandbox.
  doCheck = false;

  doInstallCheck = true;

  meta = {
    description = "Tool for analyzing parameter and XSS scanning";
    homepage = "https://github.com/hahwul/dalfox";
    changelog = "https://github.com/hahwul/dalfox/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dalfox";
  };
})
