{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "prowler";
  version = "3.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "prowler-cloud";
    repo = "prowler";
    rev = "refs/tags/${version}";
    hash = "sha256-QauDqeCa499AcZurGjn2Yv4GH04F/pahAH2ms7gAca4=";
  };

  pythonRelaxDeps = [
    "azure-mgmt-security"
    "boto3"
    "botocore"
    "google-api-python-client"
    "slack-sdk"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    alive-progress
    awsipranges
    azure-identity
    azure-mgmt-authorization
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
    msgraph-core
    msrestazure
    pydantic_1
    schema
    shodan
    slack-sdk
    tabulate
  ];

  pythonImportsCheck = [
    "prowler"
  ];

  meta = with lib; {
    description = "Security tool for AWS, Azure and GCP to perform Cloud Security best practices assessments";
    homepage = "https://github.com/prowler-cloud/prowler";
    changelog = "https://github.com/prowler-cloud/prowler/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "prowler";
  };
}
