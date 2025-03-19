{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "aws-sso-util";
  version = "4.33.0";
  pyproject = true;

  src = fetchPypi {
    pname = "aws_sso_util";
    inherit version;
    hash = "sha256-5I1/WRFENFDSjhrBYT+BuaoVursbIFW0Ux34fbQ6Cd8=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    aws-error-utils
    aws-sso-lib
    boto3
    click
    jsonschema
    python-dateutil
    pyyaml
    requests
  ];

  meta = {
    description = "Utilities to make AWS SSO easier";
    homepage = "https://pypi.org/project/aws-sso-util/";
    downloadPage = "https://pypi.org/project/aws-sso-util/#files";
    changelog = "https://github.com/benkehoe/aws-sso-util/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cterence ];
    mainProgram = "aws-sso-util";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
