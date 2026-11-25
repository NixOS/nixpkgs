{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cartography";
  version = "0.145.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cartography-cncf";
    repo = "cartography";
    tag = finalAttrs.version;
    hash = "sha256-n7ItG3cCeaN+EPOwInmGwAJob1MRpU2RK+SwsSn7p6M=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    aioboto3
    azure-identity
    azure-keyvault-certificates
    azure-keyvault-keys
    azure-keyvault-secrets
    azure-mgmt-authorization
    azure-mgmt-compute
    azure-mgmt-containerinstance
    azure-mgmt-containerservice
    azure-mgmt-cosmosdb
    azure-mgmt-datafactory
    azure-mgmt-eventgrid
    azure-mgmt-eventhub
    azure-mgmt-keyvault
    azure-mgmt-logic
    azure-mgmt-managementgroups
    azure-mgmt-monitor
    azure-mgmt-network
    azure-mgmt-resource
    azure-mgmt-resource-subscriptions
    azure-mgmt-security
    azure-mgmt-sql
    azure-mgmt-storage
    azure-mgmt-synapse
    azure-mgmt-web
    azure-storage-blob
    azure-synapse-artifacts
    backoff
    boto3
    botocore
    cloudflare
    crowdstrike-falconpy
    cryptography
    dnspython
    duo-client
    google-api-python-client
    google-auth
    google-cloud-aiplatform
    google-cloud-artifact-registry
    google-cloud-asset
    google-cloud-resource-manager
    google-cloud-run
    google-cloud-storage
    httpx
    kubernetes
    marshmallow
    modal
    msgraph-sdk
    msrestazure
    neo4j
    oci
    okta
    packageurl-python
    packaging
    pagerduty
    policyuniverse
    pydo
    pyjwt
    python-dateutil
    pyyaml
    requests
    scaleway
    slack-sdk
    statsd
    typer
    types-aiobotocore-ecr
    urllib3
    workos
    xmltodict
  ];

  # optional-dependencies = with python3Packages; {
  #   neo4j-rust = [ neo4j-rust-ext ];
  # };

  nativeCheckInputs = with python3Packages; [
    moto
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    testcontainers
  ];

  disabledTestPaths = [
    # Iintegration tests require a running Neo4j instance
    "tests/integration"
  ];

  disabledTests = [
    # V1PolicyRule missing 'non_resource_names' field
    "test_transform_roles_keeps_rules_with_api_field_names"
  ];

  pythonImportsCheck = [ "cartography" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool that pulls infrastructure assets and their relationships into a Neo4j graph database";
    homepage = "https://github.com/cartography-cncf/cartography";
    changelog = "https://github.com/cartography-cncf/cartography/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cartography";
  };
})
