{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Doesn't work with latest pydantic
      py-ocsf-models = super.py-ocsf-models.overridePythonAttrs (oldAttrs: rec {
        dependencies = [
          python3.pkgs.pydantic_1
          python3.pkgs.cryptography
          python3.pkgs.email-validator
        ];
      });
    };
  };
in
py.pkgs.buildPythonApplication rec {
  pname = "prowler";
  version = "5.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "prowler";
    tag = version;
    hash = "sha256-SC3C8JSe0n8aHwP8gelh+tDrLO6HiGN+7/Rcxhwr6Ec=";
  };

  pythonRelaxDeps = true;

  build-system = with py.pkgs; [ poetry-core ];

  dependencies = with py.pkgs; [
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
    pydantic_1
    pygithub
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
    changelog = "https://github.com/prowler-cloud/prowler/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "prowler";
  };
}
