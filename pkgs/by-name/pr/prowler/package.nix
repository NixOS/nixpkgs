{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prowler";
  version = "3.15.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "prowler";
    rev = "refs/tags/${version}";
    hash = "sha256-7aWWaGdHTveFwXsFNj4+tjX5g83/nD77jLAOrDOw8JE=";
  };

  pythonRelaxDeps = [
    "azure-identity"
    "azure-keyvault-keys"
    "azure-mgmt-compute"
    "azure-mgmt-containerservice"
    "azure-mgmt-network"
    "azure-mgmt-security"
    "azure-mgmt-storage"
    "azure-storage-blob"
    "boto3"
    "botocore"
    "google-api-python-client"
    "jsonschema"
    "pydantic"
    "pydantic"
    "slack-sdk"
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
    azure-keyvault-keys
    azure-mgmt-applicationinsights
    azure-mgmt-authorization
    azure-mgmt-compute
    azure-mgmt-containerservice
    azure-mgmt-cosmosdb
    azure-mgmt-keyvault
    azure-mgmt-monitor
    azure-mgmt-network
    azure-mgmt-rdbms
    azure-mgmt-resource
    azure-mgmt-security
    azure-mgmt-sql
    azure-mgmt-storage
    azure-mgmt-subscription
    azure-mgmt-web
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
