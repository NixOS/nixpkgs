{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "containeryard";
  version = "0.3.12";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mcmah309";
    repo = "containeryard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jXjr8y8QorpFamLIFVb3vJMH0FUrk2jZraxKtgdLev4=";
  };

  cargoHash = "sha256-VbIY7SF8imVTEGbQT2QI+lbPtkbfbGXJZVukVQvHX+E=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Declarative, reproducible, and reusable decentralized approach for defining containers";
    homepage = "https://github.com/mcmah309/containeryard";
    changelog = "https://github.com/mcmah309/containeryard/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.mcmah309 ];
    mainProgram = "yard";
  };
})
