{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mqattack";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "mqattack";
    tag = finalAttrs.version;
    hash = "sha256-cLUct4ECIbkLqU0U5SJgcvE2E8mlI3ez0dL+EZPWIlk=";
  };

  cargoHash = "sha256-E16TfqDT6svCGXlPvzOkQSumUQk9MjA8w0QWt6V40XI=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MQTT penetration testing tool";
    homepage = "https://github.com/affolter-engineering/mqattack";
    changelog = "https://github.com/affolter-engineering/mqattack/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mqattack";
  };
})
