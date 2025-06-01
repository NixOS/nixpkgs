{
  lib,
  python3,
  fetchFromGitLab,
  git,
  openssh,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "marge-bot";
  version = "0.15.3";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "marge-org";
    repo = "marge-bot";
    rev = version;
    hash = "sha256-i/hnfoBxgP1mo4RV4F10+QOOkPP/fkcwqaLKBlOuP0I=";
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

  meta = with lib; {
    description = "Merge bot for GitLab";
    homepage = "https://gitlab.com/marge-org/marge-bot";
    changelog = "https://gitlab.com/marge-org/marge-bot/-/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "marge.app";
  };
}
