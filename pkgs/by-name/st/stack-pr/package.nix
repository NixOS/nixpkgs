{
  lib,
  fetchFromGitHub,
  gh,
  git,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "stack-pr";
  version = "0.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modular";
    repo = "stack-pr";
    tag = finalAttrs.version;
    hash = "sha256-bOzSUE0bRMV6mskFjEJ0hDOnS7YpCrEpREf8ASXJkdU=";
  };

  __structuredAttrs = true;

  build-system = with python3Packages; [ pdm-backend ];

  dependencies = lib.optionals (python3Packages.pythonOlder "3.13") [
    python3Packages.typing-extensions
  ];

  nativeCheckInputs = [
    git
  ]
  ++ (with python3Packages; [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ]);

  preCheck = ''
    git init
    git config user.email "nix-build@example.invalid"
    git config user.name "Nix build"
    git commit --allow-empty -m "Initialize test repository"
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      gh
      git
    ])
  ];

  pythonImportsCheck = [ "stack_pr" ];

  meta = {
    description = "CLI for working with stacked GitHub pull requests";
    homepage = "https://github.com/modular/stack-pr";
    changelog = "https://github.com/modular/stack-pr/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ evanwporter ];
    mainProgram = "stack-pr";
  };
})
