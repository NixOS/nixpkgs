{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "git-remote-s3";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "git-remote-s3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5WsDPdqhyS6LCR6226qp2xZqUsdPO9yPO5n7h4s0Z0g=";
  };

  dependencies = [
    python3Packages.boto3
    python3Packages.botocore
    python3Packages.urllib3
  ];

  build-system = [ python3Packages.poetry-core ];

  meta = {
    homepage = "https://github.com/awslabs/git-remote-s3";
    description = "Git remote helper to use S3 as a git remote and LFS server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ CosmicLatte914 ];
    mainProgram = "git-remote-s3";
  };
})
