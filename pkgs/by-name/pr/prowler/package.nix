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
  version = "5.12.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "prowler";
    tag = version;
    hash = "sha256-6RPtld95MauhCmSLrgncr4+s16z0PfmiiC6eAph8ZmI=";
  };

  pythonRelaxDeps = true;

  build-system = with py.pkgs; [ poetry-core ];

  dependencies = with py.pkgs; [
    alive-progress
    awsipranges
    azure-identity
    azure-keyvault-keys
    azure-mgmt-apimanagement
    azure-mgmt-applicationinsights
    azure-mgmt-authorization
    azure-mgmt-compute
    azure-mgmt-containerregistry
    azure-mgmt-containerservice
    azure-mgmt-cosmosdb
    azure-mgmt-databricks
    azure-mgmt-keyvault
    azure-mgmt-loganalytics
    azure-mgmt-monitor
    azure-mgmt-network
    azure-mgmt-rdbms
    azure-mgmt-recoveryservices
    azure-mgmt-recoveryservicesbackup
    azure-mgmt-resource
    azure-mgmt-search
    azure-mgmt-security
    azure-mgmt-sql
    azure-mgmt-storage
    azure-mgmt-subscription
    azure-mgmt-web
    azure-monitor-query
    azure-storage-blob
    boto3
    botocore
    colorama
    cryptography
    dash
    dash-bootstrap-components
    detect-secrets
    dulwich
    google-api-python-client
    google-auth-httplib2
    jsonschema
    kubernetes
    microsoft-kiota-abstractions
    msgraph-sdk
    numpy
    pandas
    py-iam-expand
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
