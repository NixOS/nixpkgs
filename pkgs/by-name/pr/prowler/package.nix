{
  lib,
  python3,
  fetchFromGitHub,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "prowler";
  version = "5.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "prowler";
    tag = finalAttrs.version;
    hash = "sha256-GRVVyHqAjTsC02Ba7963xP3dutH6KmpSYvHI2eWyehE=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
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
    azure-mgmt-postgresqlflexibleservers
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
    h2
    jsonschema
    kubernetes
    markdown
    microsoft-kiota-abstractions
    msgraph-sdk
    numpy
    oci
    pandas
    py-iam-expand
    py-ocsf-models
    pydantic
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Security tool for AWS, Azure and GCP to perform Cloud Security best practices assessments";
    homepage = "https://github.com/prowler-cloud/prowler";
    changelog = "https://github.com/prowler-cloud/prowler/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "prowler";
  };
})
