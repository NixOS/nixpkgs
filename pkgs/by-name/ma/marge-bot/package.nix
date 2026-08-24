{
  lib,
  fetchFromGitLab,
  python3Packages,
  git,
  openssh,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "marge-bot";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "marge-org";
    repo = "marge-bot";
    rev = finalAttrs.version;
    hash = "sha256-Wg+yWkHkCbry13SRaEvULF4jjCaBI524FsVfcP/+u/k=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-build
  ];

  dependencies =
    (with python3Packages; [
      configargparse
      pyyaml
      requests
      python-gitlab
    ])
    ++ [
      git
      openssh
    ];

  nativeCheckInputs =
    (with python3Packages; [
      pytest-cov-stub
      pytestCheckHook
      python-dateutil
      time-machine
    ])
    ++ [
      git
    ];

  pythonImportsCheck = [ "marge" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Merge bot for GitLab";
    homepage = "https://gitlab.com/marge-org/marge-bot";
    changelog = "https://gitlab.com/marge-org/marge-bot/-/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bcdarwin
      lelgenio
    ];
    mainProgram = "marge.app";
  };
})
