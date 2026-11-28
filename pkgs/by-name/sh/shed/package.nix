{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "shed";
  version = "2025.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Zac-HD";
    repo = "shed";
    tag = finalAttrs.version;
    hash = "sha256-VF9AsF+hEO4W2lsuZvPQRtJGx2NcRQqjiijSWgQ9kVo=";
  };

  postUnpack = ''
    # Tests depend on the source being in a directory named `shed`
    mv "$sourceRoot" shed
    sourceRoot=shed
  '';

  build-system = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [
    black
    com2ann
    libcst
    pyupgrade
    ruff
  ];

  nativeCheckInputs =
    (with python3Packages; [
      pytestCheckHook
      pytest-cov
      flake8-comprehensions
      hypothesis
      hypothesmith
      ruff
    ])
    ++ [ git ];
  preCheck = ''
    git -c advice.defaultBranchName=false init
  '';
  disabledTests = [
    # Formatting differs with current versions of dependencies.
    "test_saved_examples[C413-"
  ];
  pythonImportsCheck = [ "shed" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Canonicalises Python code";
    homepage = "https://github.com/Zac-HD/shed";
    changelog = "https://github.com/Zac-HD/shed/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    mainProgram = "shed";
    maintainers = with lib.maintainers; [ winter ];
  };
})
