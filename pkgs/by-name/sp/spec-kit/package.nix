{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "spec-kit";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "spec-kit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XtI6F9mB+Q1qvwCDPaqgv2ewIzqN9ybWLFOHi2DqOag=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    json5
    packaging
    pathspec
    platformdirs
    pyyaml
    readchar
    rich
    typer
  ];

  pythonImportsCheck = [
    "specify_cli"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bootstrap your projects for Spec-Driven Development (SDD)";
    homepage = "https://github.com/github/spec-kit";
    changelog = "https://github.com/github/spec-kit/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.luochen1990
      lib.maintainers."3mp3ri0r"
    ];
    mainProgram = "specify";
  };
})
