{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prowler";
  version = "3.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "prowler";
    rev = "refs/tags/${version}";
    hash = "sha256-19B6b+xR+f7dIu/6eINsxs7UxuV96QdsNncodC8/N3Q=";
  };

  pythonRelaxDeps = [
    "azure-mgmt-security"
    "azure-storage-blob"
    "boto3"
    "botocore"
    "google-api-python-client"
    "jsonschema"
    "pydantic"
    "slack-sdk"
    "pydantic"
  ];

  nativeBuildInputs = with python3.pkgs; [
    pythonRelaxDepsHook
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    alive-progress
    awsipranges
    azure-identity
    azure-mgmt-applicationinsights
    azure-mgmt-authorization
    azure-mgmt-cosmosdb
    azure-mgmt-rdbms
    azure-mgmt-security
    azure-mgmt-sql
    azure-mgmt-storage
    azure-mgmt-subscription
    azure-storage-blob
    boto3
    botocore
    colorama
    detect-secrets
    google-api-python-client
    google-auth-httplib2
    jsonschema
    msgraph-sdk
    msrestazure
    pydantic_1
    schema
    shodan
    slack-sdk
    tabulate
  ];

  pythonImportsCheck = [ "prowler" ];

  meta = with lib; {
    description = "Security tool for AWS, Azure and GCP to perform Cloud Security best practices assessments";
    homepage = "https://github.com/prowler-cloud/prowler";
    changelog = "https://github.com/prowler-cloud/prowler/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "prowler";
  };
}
