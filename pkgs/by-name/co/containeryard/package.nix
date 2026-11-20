{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "containeryard";
  version = "0.4.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mcmah309";
    repo = "containeryard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-njd2tiQK920xpp8dFTKgUHJuy/VJf7Fh8uQEz+7DYQk=";
  };

  cargoHash = "sha256-Ix6KK2pnWkg8sT2c+Y59kIciFfB3BZ7keWwH9w45Myw=";

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
