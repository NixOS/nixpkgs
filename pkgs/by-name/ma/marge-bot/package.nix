{
  lib,
  python3,
  fetchFromGitLab,
  git,
  openssh,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "marge-bot";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "marge-org";
    repo = "marge-bot";
    rev = version;
    hash = "sha256-UgdbeJegeTFP6YF6oMxAeQDI9AO2k6yk4WAFZ/Xspu8=";
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

  meta = with lib; {
    description = "Merge bot for GitLab";
    homepage = "https://gitlab.com/marge-org/marge-bot";
    changelog = "https://gitlab.com/marge-org/marge-bot/-/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      bcdarwin
      lelgenio
    ];
    mainProgram = "marge.app";
  };
}
