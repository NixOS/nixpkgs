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
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkniewallner";
    repo = "migrate-to-uv";
    tag = version;
    hash = "sha256-+ONnunsq5DGHmAZu51SeJevHXsQbv6/upHhETJmDMMM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
    hash = "sha256-7PwshE0g2sVp8xweV3OTt7LwkwqGFfCJb3DoX1zfzS8=";
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
