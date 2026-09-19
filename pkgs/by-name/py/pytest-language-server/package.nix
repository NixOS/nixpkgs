{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pytest-language-server";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "bellini666";
    repo = "pytest-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yi7NW29jKGxl6N5NVpTGArnk5cUq8/+eL6PDyWsAXlw=";
  };

  cargoHash = "sha256-cSbJYu6OVfUssNZbKGrixA1+UlOf+5/DIdXjkAKo7cQ=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server Protocol implementation for pytest";
    homepage = "https://github.com/bellini666/pytest-language-server";
    changelog = "https://github.com/bellini666/pytest-language-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ barrettruth ];
    mainProgram = "pytest-language-server";
  };
})
