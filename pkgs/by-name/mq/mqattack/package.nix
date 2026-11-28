{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mqattack";
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "mqattack";
    tag = finalAttrs.version;
    hash = "sha256-b3CTGEfN0GIlKzTTSbr3+hOqmhPnHxDHwLoROOpDYOA=";
  };

  cargoHash = "sha256-DnAgrjnLa4yQfGWJE5KDmElJzD3iQwhQgd08liZjBEQ=";

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
