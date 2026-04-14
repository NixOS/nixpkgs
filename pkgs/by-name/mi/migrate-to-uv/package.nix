{
  lib,
  python3,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  versionCheckHook,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "migrate-to-uv";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkniewallner";
    repo = "migrate-to-uv";
    tag = finalAttrs.version;
    hash = "sha256-+UXPgFYgTlLmUYpE2aWsO2OdelP9dCZsB3cWjG4negA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src pname version;
    hash = "sha256-evsc5uOZnN6+tRXmN1SQD5Iqnm4Y+TjmBzWaGQQj2UQ=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Migrate a project from Poetry/Pipenv/pip-tools/pip to uv package manager";
    homepage = "https://mkniewallner.github.io/migrate-to-uv/";
    changelog = "https://github.com/mkniewallner/migrate-to-uv/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "migrate-to-uv";
  };
})
