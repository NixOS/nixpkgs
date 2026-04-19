{
  lib,
  pkgs,
  fetchFromGitHub,
  python3Packages,
  buildNpmPackage,
  writableTmpDirAsHomeHook,
}:
let
  pname = "skypilot";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "skypilot-org";
    repo = "skypilot";
    tag = "v${version}";
    hash = "sha256-zxkduComvFuSbWnWSw1PYalGdVhiwCIjElXEg7VPw88=";
  };

  dashboard = buildNpmPackage {
    inherit pname version src;

    sourceRoot = "${src.name}/sky/dashboard";
    npmDepsHash = "sha256-8uZzkDJkaDPFXXsGy29jkaw6g8bPe3drbboYHHa6YuU=";

    installPhase = ''
      mkdir -p $out
      cp -r out/* $out/
    '';
  };
in
python3Packages.buildPythonApplication (finalAttrs: {
  inherit pname version src;

  pyproject = true;
  pythonRelaxDeps = true;

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  postPatch = ''
    substituteInPlace sky/setup_files/dependencies.py --replace-fail 'casbin' 'pycasbin'
    substituteInPlace pyproject.toml --replace-fail 'buildkite-test-collector' ""
  '';

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  # https://github.com/skypilot-org/skypilot/blob/master/sky/setup_files/dependencies.py
  dependencies =
    with python3Packages;
    [
      aiohttp
      aiofiles
      aiosqlite
      alembic
      asyncpg
      bcrypt
      cachetools
      click
      colorama
      cryptography
      filelock
      fastapi
      gitpython
      httpx
      ijson
      jinja2
      jsonschema
      networkx
      packaging
      pandas
      paramiko
      passlib
      pendulum
      pip
      prettytable
      prometheus-client
      psutil
      psycopg2-binary
      pycasbin
      pydantic
      pyjwt
      python-dotenv
      pyyaml
      python-multipart
      pulp
      requests
      rich
      setproctitle
      sqlalchemy
      sqlalchemy-adapter
      tabulate
      types-paramiko
      typing-extensions
      uvicorn
      wheel
    ]
    ++ aiohttp.optional-dependencies.speedups
    ++ fastapi.optional-dependencies.all
    ++ uvicorn.optional-dependencies.standard;

  optional-dependencies =
    with python3Packages;
    lib.fix (self: {

      all = with self; [
        aws
        azure
        cloudfare
        docker
        fluidstack
        gcp
        ibm
        kubernates
        lambda
        paperspace
        ray
        remote
        server
        scp
        ssh
        vsphere
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
      ]
      ++ self.ray;

      cloudfare = self.aws;

      #    cudo = [cudo-compute];
      #
      #    do = [pydo azure-core azure-common];

      docker = [ docker ];

      fluidstack = [ ];

      gcp = [
        google-api-python-client
        google-cloud-storage
        pyopenssl
      ];

      ibm = [
        ibm-cloud-sdk-core
        #      ibm-cos-sdk
        #      ibm-platform-services
        #      ibm-vpc
      ]
      ++ self.ray;

      kubernetes = [
        kubernetes
        websockets
      ];

      lambda = [ ];

      #    nebius = [
      #      nebius
      #    ]
      #    ++ self.aws;

      paperspace = [ ];

      ray = [ ray ] ++ ray.optional-dependencies.default;

      remote = [
        grpcio
        protobuf
      ];

      # runpod = [ runpod ];

      server = [
        pycasbin
        passlib
        pyjwt
        sqlalchemy-adapter
      ];

      scp = self.ray;

      ssh = self.kubernetes;

      # vast = [vastai-sdk];

      vsphere = [
        pyvmomi
        # vsphere-automation-sdk
      ];
    });

  postInstall = ''
    mkdir -p $out/${python3Packages.python.sitePackages}/sky/dashboard/out
    cp -r ${dashboard}/* $out/${python3Packages.python.sitePackages}/sky/dashboard/out/
  '';

  # Excluding the tests as it fails with error:
  # Message: 'Config loaded from /build/source/examples/admin_policy/restful_policy.yaml:\nadmin_policy: http://localhost:8080\n'
  #Arguments: ()
  #--- Logging error ---
  #Traceback (most recent call last):
  #  File "/nix/store/pzdalg368npikvpq4ncz2saxnz19v53k-python3-3.13.12/lib/python3.13/logging/__init__.py", line 1154, in emit
  #    stream.write(msg + self.terminator)
  #    ~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^
  #ValueError: I/O operation on closed file.
  #  nativeCheckInputs = with python3Packages; [
  #    pytestCheckHook
  #    boto3
  #    pytest-env
  #    pytest-xdist
  #  ];

  pythonImportsCheck = [
    "sky"
  ];

  meta = {
    description = "Run LLMs and AI on any Cloud";
    longDescription = ''
      SkyPilot is a framework for running LLMs, AI, and batch jobs on any
      cloud, offering maximum cost savings, highest GPU availability, and
      managed execution.
    '';
    homepage = "https://github.com/skypilot-org/skypilot";
    changelog = "https://github.com/skypilot-org/skypilot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      seanrmurphy
      daspk04
    ];
    mainProgram = "sky";
  };
})
