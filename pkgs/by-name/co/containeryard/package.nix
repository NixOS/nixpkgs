{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "containeryard";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mcmah309";
    repo = "containeryard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fWbrzIqn0KIHDiIrX7ZGgV9sSy2L0NQTDx8w0kCcwR0=";
  };

  cargoHash = "sha256-GPhtHezpWYzyjMEpyDDLGOan2HPkB4PoTCSM4N9BpuI=";

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
