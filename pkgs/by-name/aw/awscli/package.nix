{
  lib,
  python3Packages,
  fetchFromGitHub,
  cacert,
  groff,
  less,
  nix-update-script,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "awscli";
  version = "1.46.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    tag = finalAttrs.version;
    hash = "sha256-qA4FOgzulvGDQoCDeooID/A7ASfVi25NJayOxTc6wqo=";
  };

  postPatch = ''
    ln -sf ${cacert}/etc/ssl/certs/ca-no-trust-rules-bundle.crt awscli/botocore/cacert.pem
  '';

  pythonRelaxDeps = [
    "docutils"
    "rsa"
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    docutils
    jmespath
    python-dateutil
    urllib3
    pyyaml
    colorama
    rsa

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

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/aws --version | grep "${finalAttrs.version}"

    runHook postInstallCheck
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

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
  };
})
