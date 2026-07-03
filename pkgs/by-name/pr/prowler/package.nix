{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "prowler";
  version = "5.31.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "prowler";
    tag = finalAttrs.version;
    hash = "sha256-V3kPj3gtS8ZkeU/rBaTPaOdfWvYI70jAi52kCX0m/jg=";
  };

  pythonRelaxDeps = true;

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    alibabacloud-actiontrail20200706
    alibabacloud-credentials
    alibabacloud-cs20151215
    alibabacloud-ecs20140526
    alibabacloud-oss20190517
    alibabacloud-ram20150501
    alibabacloud-sas20181203
    alibabacloud-sts20150401
    alibabacloud-tea-openapi
    alibabacloud-vpc20160428
    alibabacloud-gateway-oss-util
    alibabacloud-rds20140815
    alibabacloud-sls20201230
    alive-progress
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
    cloudflare
    colorama
    cryptography
    dash
    dash-bootstrap-components
    defusedxml
    detect-secrets
    dulwich
    google-api-python-client
    google-auth-httplib2
    h2
    jsonschema
    kubernetes
    linode-api4
    markdown
    microsoft-kiota-abstractions
    msgraph-sdk
    numpy
    oci
    okta
    openstacksdk
    pandas
    py-iam-expand
    py-ocsf-models
    pydantic
    pygithub
    python-dateutil
    pytz
    scaleway
    schema
    shodan
    slack-sdk
    stackit-core
    stackit-iaas
    stackit-objectstorage
    stackit-resourcemanager
    tabulate
    tzlocal
    uuid6
  ];

  pythonImportsCheck = [ "prowler" ];

  meta = {
    description = "Security tool to perform Cloud Security best practices assessments";
    homepage = "https://github.com/prowler-cloud/prowler";
    changelog = "https://github.com/prowler-cloud/prowler/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "prowler";
  };
})
