{
  lib,
  python3Packages,
  fetchFromGitHub,
  groff,
  less,
  nix-update-script,
  testers,
  awscli,
}:

let
  self = python3Packages.buildPythonApplication rec {
    pname = "awscli";
    # N.B: if you change this, change botocore and boto3 to a matching version too
    # check e.g. https://github.com/aws/aws-cli/blob/1.33.21/setup.py
    version = "1.42.18";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "aws";
      repo = "aws-cli";
      tag = version;
      hash = "sha256-f6CVQotsdvU2g/GjOMWPay/7FxxRvhtBrVZE5TLHTNY=";
    };

    pythonRelaxDeps = [
      # botocore must not be relaxed
      "docutils"
      "rsa"
    ];

    build-system = with python3Packages; [
      setuptools
    ];

    dependencies = with python3Packages; [
      botocore
      docutils
      s3transfer
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

      $out/bin/aws --version | grep "${python3Packages.botocore.version}"
      $out/bin/aws --version | grep "${version}"

      runHook postInstallCheck
    '';

    passthru = {
      python = python3Packages.python; # for aws_shell
      updateScript = nix-update-script {
        extraArgs = [ "--version=skip" ];
      };
      tests.version = testers.testVersion {
        package = awscli;
        command = "aws --version";
        inherit version;
      };
    };

    meta = {
      homepage = "https://aws.amazon.com/cli/";
      changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
      description = "Unified tool to manage your AWS services";
      license = lib.licenses.asl20;
      mainProgram = "aws";
      maintainers = with lib.maintainers; [ anthonyroussel ];
    };
  };
in
assert self ? pythonRelaxDeps -> !(lib.elem "botocore" self.pythonRelaxDeps);
self
