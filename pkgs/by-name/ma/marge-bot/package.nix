{
  lib,
  python3,
  fetchFromGitLab,
  git,
  openssh,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "marge-bot";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "marge-org";
    repo = "marge-bot";
    rev = finalAttrs.version;
    hash = "sha256-FKUWVJqkhdxlWcOvyACQo/At0qW9Li+l25+9oCnA4nM=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];

  propagatedBuildInputs =
    (with python3.pkgs; [
      configargparse
      maya
      pyyaml
      requests
      python-gitlab
      hatchling
    ])
    ++ [
      git
      openssh
    ];

  nativeCheckInputs =
    (with python3.pkgs; [
      pytest-cov-stub
      pytestCheckHook
      pendulum
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
