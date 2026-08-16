{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "scoutsuite";
  version = "5.14.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nccgroup";
    repo = "scoutsuite";
    tag = finalAttrs.version;
    hash = "sha256-bSnmb1grm8aoRjvvuc30QKBjcKz8wxnDXMdzFMDkiDE=";
  };

  pythonRelaxDeps = [
    "asyncio-throttle"
    "azure-identity"
    "azure-mgmt-authorization"
    "azure-mgmt-compute"
    "azure-mgmt-keyvault"
    "azure-mgmt-monitor"
    "azure-mgmt-network"
    "azure-mgmt-rdbms"
    "azure-mgmt-redis"
    "azure-mgmt-resource"
    "azure-mgmt-security"
    "azure-mgmt-sql"
    "azure-mgmt-storage"
    "azure-mgmt-web"
    "coloredlogs"
    "google-cloud-kms"
    "google-cloud-monitoring"
    "httplib2shim"
    "msgraph-core"
    "python-dateutil"
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aliyun-python-sdk-actiontrail
    aliyun-python-sdk-core
    aliyun-python-sdk-ecs
    aliyun-python-sdk-kms
    aliyun-python-sdk-ocs
    aliyun-python-sdk-ram
    aliyun-python-sdk-rds
    aliyun-python-sdk-sts
    aliyun-python-sdk-vpc
    asyncio-throttle
    azure-identity
    azure-mgmt-authorization
    azure-mgmt-compute
    azure-mgmt-keyvault
    azure-mgmt-monitor
    azure-mgmt-network
    azure-mgmt-rdbms
    azure-mgmt-redis
    azure-mgmt-resource
    azure-mgmt-security
    azure-mgmt-sql
    azure-mgmt-storage
    azure-mgmt-web
    boto3
    botocore
    cherrypy
    cherrypy-cors
    coloredlogs
    google-api-python-client
    google-cloud-container
    google-cloud-core
    google-cloud-iam
    google-cloud-kms
    google-cloud-logging
    google-cloud-monitoring
    google-cloud-resource-manager
    google-cloud-storage
    grpcio
    httplib2shim
    kubernetes
    msgraph-core
    netaddr
    oauth2client
    oci
    oss2
    policyuniverse
    pydo
    python-dateutil
    sqlitedict
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "ScoutSuite" ];

  disabledTests = [
    # AssertionError
    "test_scout_suite_help"
    "test_snake_case"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-Cloud Security Auditing Tool";
    homepage = "https://github.com/nccgroup/scoutsuite";
    changelog = "https://github.com/nccgroup/scoutsuite/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "scout";
  };
})
