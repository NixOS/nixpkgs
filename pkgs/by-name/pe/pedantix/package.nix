{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pedantix";
  version = "1.2.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Swarsel";
    repo = "pedantix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nDAJ7Th/e08LPseucE9lBfcNgZUURdlrI9IShm86WZM=";
  };

  cargoHash = "sha256-u9Fn1GphndiUlIWRBHMKVP/9N0CYOPAQUwLvpAVysrM=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The pedantic nix formatter";
    homepage = "https://github.com/Swarsel/pedantix";
    changelog = "https://github.com/Swarsel/pedantix/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swarsel ];
    mainProgram = "pedantix";
  };
})
