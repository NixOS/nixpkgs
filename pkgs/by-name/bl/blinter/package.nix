{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "blinter";
  version = "1.0.112";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tboy1337";
    repo = "Blinter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qWcNhHv9GuFBZXJ4BDgqEXVUUypK2qV5iS2ijdpHTJE=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  dependencies = with python3Packages; [
    charset-normalizer
  ];

  pythonImportsCheck = [
    "blinter"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linter for Windows batch files";
    homepage = "https://github.com/tboy1337/Blinter";
    changelog = "https://github.com/tboy1337/Blinter/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      agpl3Only
      agpl3Plus
    ];
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "blinter";
  };
})
