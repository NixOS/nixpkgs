{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "spec-kit";
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "github";
    repo = "spec-kit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jQ2Mp6Ya1Bs/SYbmSEK3LoNtqjeHtJCgn3a7RMmokW8=";
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
      json5
      pyyaml
      packaging
      pathspec
    ]
    ++ httpx.optional-dependencies.socks;

  pythonImportsCheck = [
    "specify_cli"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bootstrap your projects for Spec-Driven Development (SDD)";
    homepage = "https://github.com/github/spec-kit";
    changelog = "https://github.com/github/spec-kit/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luochen1990 ];
    mainProgram = "specify";
  };
})
