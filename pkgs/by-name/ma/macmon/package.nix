{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "macmon";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "vladkens";
    repo = "macmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GiSF5PBRUcKZzd9vWf9MmKKZbtqchnu0DjFgbXmp7bg=";
  };

  cargoHash = "sha256-b9CpHSC3/kj7lHs+QhDqnRZfda9rtJJEs3j24NDZSPQ=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Sudoless performance monitoring for Apple Silicon processors";
    homepage = "https://github.com/vladkens/macmon";
    changelog = "https://github.com/vladkens/macmon/releases/tag/${finalAttrs.src.tag}";
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ schrobingus ];
    mainProgram = "macmon";
  };
})
