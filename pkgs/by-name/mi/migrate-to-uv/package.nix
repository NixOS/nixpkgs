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
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.7.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkniewallner";
    repo = "migrate-to-uv";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-l8YJVOWNtvN13fEZp6L0fwmUu12jV7xxQBp3Glr+Df4=";
=======
    hash = "sha256-hLcWZKY1wauGpcAn+tC4P1zvFid7QDVXUK24QSIJ4u0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src pname version;
<<<<<<< HEAD
    hash = "sha256-35BBfNz3h/KpchCcUnoHN46znkQ7UuhhliWdgCYPw20=";
=======
    hash = "sha256-nyJ2UbdBcNX8mNpq447fM2QuscTdJwnjqP7AKBKv7kY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
