{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "spec-kit";
  version = "0.0.86";

  src = fetchFromGitHub {
    owner = "github";
    repo = "spec-kit";
    tag = "v${version}";
    hash = "sha256-zgiJN7rzD5x/xpL6CMvxITy+/YTu1TKk26UhhQ/s5V8=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies =
    with python3Packages;
    [
      typer
      rich
      httpx
      platformdirs
      readchar
      truststore
    ]
    ++ httpx.optional-dependencies.socks;

  pythonImportsCheck = [
    "specify_cli"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bootstrap your projects for Spec-Driven Development (SDD)";
    homepage = "https://github.com/github/spec-kit";
    changelog = "https://github.com/github/spec-kit/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luochen1990 ];
    mainProgram = "specify";
  };
}
