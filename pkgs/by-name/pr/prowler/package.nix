{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prowler";
  version = "5.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "prowler";
    tag = version;
    hash = "sha256-aIeJp/tmVVKj65/m/qRoXZXlc2BHwbjKX1H0HUra2nA=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    alive-progress
    awsipranges
    azure-identity
    azure-keyvault-keys
    azure-mgmt-applicationinsights
    azure-mgmt-authorization
    azure-mgmt-compute
    azure-mgmt-containerregistry
    azure-mgmt-containerservice
    azure-mgmt-cosmosdb
    azure-mgmt-keyvault
    azure-mgmt-monitor
    azure-mgmt-network
    azure-mgmt-rdbms
    azure-mgmt-resource
    azure-mgmt-security
    azure-mgmt-search
    azure-mgmt-sql
    azure-mgmt-storage
    azure-mgmt-subscription
    azure-mgmt-web
    azure-storage-blob
    boto3
    botocore
    colorama
    cryptography
    dash
    dash-bootstrap-components
    detect-secrets
    google-api-python-client
    google-auth-httplib2
    jsonschema
    kubernetes
    microsoft-kiota-abstractions
    msgraph-sdk
    numpy
    pandas
    py-ocsf-models
    pydantic
    python-dateutil
    pytz
    schema
    shodan
    slack-sdk
    tabulate
    tzlocal
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
