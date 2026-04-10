{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jwt-hack";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "jwt-hack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C/K4AG+qQwgo58EwN+k3Bys9qgV59xfRNVCtZmjtcRM=";
  };

  cargoHash = "sha256-0WS8+6wFpWWz6jqPdr5F4CURA3sHrKa2vnbDCnBF0Lo=";

  nativeBuildInputs = [ pkg-config ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = 1;

  doInstallCheck = true;

  meta = {
    description = "JSON Web Token Hack Toolkit";
    homepage = "https://github.com/hahwul/jwt-hack";
    changelog = "https://github.com/hahwul/jwt-hack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "jwt-hack";
  };
})
