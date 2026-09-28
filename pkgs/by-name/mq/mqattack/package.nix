{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mqattack";
  version = "0.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "affolter-engineering";
    repo = "mqattack";
    tag = finalAttrs.version;
    hash = "sha256-kUZatTjjpBpyrZ//JHDSki6oXVGunH0thgY0+q3wFyM=";
  };

  cargoHash = "sha256-V1RKag4AZhYaTY9vzt56F19qMAAt3BTdAliu1uKbVwQ=";

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
