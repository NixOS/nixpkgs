{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repro-env";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "repro-env";
    tag = "v${finalAttrs.version}";
    hash = "sha256-McmZ5KzWGJYx+f3rXTUQK9sVaAZW7RxA2w2o8f/3kvU=";
  };

  cargoHash = "sha256-0gTClY+jWfUpNa1aC/I5waSeZirB/sPGVno0qWYHTsA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/kpcyrd/repro-env/releases/tag/v${finalAttrs.version}";
    description = "Dependency lockfiles for reproducible build environments";
    homepage = "https://github.com/kpcyrd/repro-env";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "repro-env";
  };
})
