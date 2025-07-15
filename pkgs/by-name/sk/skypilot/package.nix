{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "skypilot";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skypilot-org";
    repo = "skypilot";
    tag = "v${version}";
    hash = "sha256-HOguSCe9YbmAqvZCiUHOeNIWH4DofmrxWoW8yDSCah8=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = with python3Packages; [
    aiofiles
    cachetools
    casbin
    click
    colorama
    cryptography
    fastapi
    filelock
    httpx
    jinja2
    jsonschema
    networkx
    packaging
    pandas
    passlib
    pendulum
    prettytable
    prometheus-client
    psutil
    psycopg2-binary
    pulp
    pydantic
    pyjwt
    python-dotenv
    python-multipart
    pyyaml
    requests
    rich
    setproctitle
    sqlalchemy
    sqlalchemy-adapter
    tabulate
    typing-extensions
    uvicorn
    wheel
  ];

  optional-dependencies = with python3Packages; {
    all = [
      awscli
      azure-cli
      azure-common
      azure-core
      azure-identity
      azure-mgmt-compute
      azure-mgmt-network
      azure-storage-blob
      boto3
      botocore
      casbin
      colorama
      cudo-compute
      docker
      google-api-python-client
      google-cloud-storage
      grpcio
      ibm-cloud-sdk-core
      ibm-cos-sdk
      ibm-platform-services
      ibm-vpc
      kubernetes
      msgraph-sdk
      nebius
      oci
      passlib
      protobuf
      pydo
      pyjwt
      pyopenssl
      pyvmomi
      ray
      runpod
      sqlalchemy-adapter
      vastai-sdk
      websockets
    ];
    aws = [
      awscli
      boto3
      botocore
      colorama
    ];
    azure = [
      azure-cli
      azure-core
      azure-identity
      azure-mgmt-compute
      azure-mgmt-network
      azure-storage-blob
      msgraph-sdk
      ray
    ];
    cloudflare = [
      awscli
      boto3
      botocore
      colorama
    ];
    cudo = [
      cudo-compute
    ];
    do = [
      azure-common
      azure-core
      pydo
    ];
    docker = [
      docker
      ray
    ];
    gcp = [
      google-api-python-client
      google-cloud-storage
      pyopenssl
    ];
    ibm = [
      ibm-cloud-sdk-core
      ibm-cos-sdk
      ibm-platform-services
      ibm-vpc
      ray
    ];
    kubernetes = [
      kubernetes
      websockets
    ];
    nebius = [
      awscli
      boto3
      botocore
      colorama
      nebius
    ];
    oci = [
      oci
      ray
    ];
    remote = [
      grpcio
      protobuf
    ];
    runpod = [
      runpod
    ];
    scp = [
      ray
    ];
    server = [
      casbin
      passlib
      pyjwt
      sqlalchemy-adapter
    ];
    ssh = [
      kubernetes
      websockets
    ];
    vast = [
      vastai-sdk
    ];
    vsphere = [
      pyvmomi
    ];
  };

  pythonImportsCheck = [
    "skypilot"
  ];

  meta = {
    description = "Run LLMs and AI on any Cloud";
    longDescription = ''
      SkyPilot is a framework for running LLMs, AI, and batch jobs on any
      cloud, offering maximum cost savings, highest GPU availability, and
      managed execution.
    '';
    homepage = "https://pypi.org/project/skypilot/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      seanrmurphy
      carlthome
    ];
    mainProgram = "sky";
  };
}
