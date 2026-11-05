{
  lib,
  python3Packages,
  fetchFromGitHub,
  groff,
  less,
  nix-update-script,
  testers,
  awscli,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "awscli";
  version = "1.46.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    tag = finalAttrs.version;
    hash = "sha256-ztKkviGERrGra/hAq6y/K+MrxfGneA6pHZK55wETyBc=";
  };

  pythonRelaxDeps = [
    "docutils"
    "rsa"
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    colorama
    docutils
    jmespath
    python-dateutil
    pyyaml
    rsa
    urllib3
  ];

  propagatedBuildInputs = [
    groff
    less
  ];

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    echo "complete -C $out/bin/aws_completer aws" > $out/share/bash-completion/completions/awscli

    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions

    rm $out/bin/aws.cmd
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    python = python3Packages.python; # for aws_shell
    updateScript = nix-update-script {
      extraArgs = [ "--version=skip" ];
    };
  };

  meta = {
    homepage = "https://aws.amazon.com/cli/";
    changelog = "https://github.com/aws/aws-cli/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
    license = lib.licenses.asl20;
    mainProgram = "aws";
    maintainers = with lib.maintainers; [ anthonyroussel ];
    problems.removal = {
      message = "AWS CLI v1 (`awscli`) is deprecated and will be removed from Nixpkgs 27.05. Please switch to `awscli2`.";
      urls = [ "https://aws.amazon.com/blogs/developer/cli-v1-maintenance-mode-announcement" ];
    };
  };
})
