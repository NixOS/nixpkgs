{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "containeryard";
  version = "0.3.13";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mcmah309";
    repo = "containeryard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aj9nFw+EXvBc3+tzy87UN2KBPaUQaOUbslnEE6rCGB0=";
  };

  cargoHash = "sha256-H1gIhQ0V1//2QVFNg9VqIkVgDI9Dm5N/6Dho+lrU1Mg=";

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
