{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hvt";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "hvt";
    tag = finalAttrs.version;
    hash = "sha256-CIPxM1cdUpb8KyKj3DpM/bGpZmRH7b2xwEOTt5/623g=";
  };

  cargoHash = "sha256-tPcE6DbnXcZ2mS8czfVRFQ6OaRyeju925zagOP0ytQM=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to do HTTP Verb Tampering";
    homepage = "https://github.com/affolter-engineering/hvt";
    changelog = "https://github.com/affolter-engineering/hvt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hvt";
  };
})
