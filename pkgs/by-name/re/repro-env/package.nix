{
  lib,
  rustPlatform,
  fetchFromGitHub,
  podman,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repro-env";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "repro-env";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d1PGEKEUSzCnXNhu/qkzl4uHnhRFULUP7aRbIsRFWn8=";
  };

  cargoHash = "sha256-HaI5oE8WVnM1h6rVaVl2qGvTndhD5cKg+Dwf707I9DA=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  env.REPRO_ENV_PODMAN_BINARY = lib.getExe' podman "podman";

  meta = {
    changelog = "https://github.com/kpcyrd/repro-env/releases/tag/v${finalAttrs.version}";
    description = "Dependency lockfiles for reproducible build environments";
    homepage = "https://github.com/kpcyrd/repro-env";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kpcyrd ];
    mainProgram = "repro-env";
  };
})
