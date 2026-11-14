{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kcwarden";
  version = "0.18.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "iteratec";
    repo = "kcwarden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tQ3bc8IuVY/39xwWbXvUyMniTZlfe0A7hkam4Tg90p8=";
  };

  build-system = [
    python3Packages.hatchling
    python3Packages.uv-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    pyyaml
    requests
    rich
  ];

  pythonImportsCheck = [
    "kcwarden"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatically audit your Keycloak configuration for security issues";
    downloadPage = "https://github.com/iteratec/kcwarden";
    homepage = "https://iteratec.github.io/kcwarden/";
    changelog = "https://github.com/iteratec/kcwarden/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "kcwarden";
  };
})
