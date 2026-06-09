{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rnsh";
  version = "0.1.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "acehoss";
    repo = "rnsh";
    tag = "release/v${finalAttrs.version}";
    hash = "sha256-nVrRW4VJINUCVX2imzddzKN7nlrjFZ1iFE8lY5GTCZA=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    rns
  ];

  pythonImportsCheck = [
    "rnsh"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTestPaths = [
    # Flaky
    "tests/test_retry.py"
    "tests/test_rnsh.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A command-line utility written in Python that facilitates shell sessions over Reticulum networks and aims to provide a similar experience to SSH";
    homepage = "https://github.com/acehoss/rnsh";
    changelog = "https://github.com/acehoss/rnsh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rnsh";
  };
})
