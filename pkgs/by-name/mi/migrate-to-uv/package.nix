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

python3.pkgs.buildPythonApplication rec {
  pname = "migrate-to-uv";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkniewallner";
    repo = "migrate-to-uv";
    tag = version;
    hash = "sha256-mN0xU9hoaWP0gQnGlZSnge/0eZwcJm3E5cBTpgXSO1E=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-KhErvN3hn5Yjt/mY/fqXhxAh+GpzmM0mkgK8MaJwbcM=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Migrate a project from Poetry/Pipenv/pip-tools/pip to uv package manager";
    homepage = "https://mkniewallner.github.io/migrate-to-uv/";
    changelog = "https://github.com/mkniewallner/migrate-to-uv/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "migrate-to-uv";
  };
}
