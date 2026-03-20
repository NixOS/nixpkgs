{
  fetchFromGitHub,
  lib,
  nix-update-script,
  nixosTests,
  python3Packages,
  versionCheckHook,

  extras ? [
    # upstream requires one of: psycopg, psycopg2
    "psycopg2"

    # distributed configuration stores
    "consul"
    "etcd"
    "etcd3"
    "exhibitor"
    "kubernetes"
    "raft"
    "zookeeper"
  ],
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "patroni";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zalando";
    repo = "patroni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iY5QLbJXfQtfkzpQxvqSOzYQwgfFsBh8HPYujqxU44k=";
  };

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [
    "ydiff" # requires <1.5
  ];

  dependencies =
    (with python3Packages; [
      click
      consul
      prettytable
      psutil
      python-dateutil
      pyyaml
      urllib3
      ydiff
    ])
    ++ lib.attrVals extras finalAttrs.passthru.optional-dependencies;

  optional-dependencies = with python3Packages; {
    aws = [ boto3 ];
    consul = [ consul ];
    etcd = [ python-etcd ];
    etcd3 = [ python-etcd ];
    exhibitor = [ kazoo ];
    jsonlogger = [ python-json-logger ];
    kubernetes = [ ];
    psycopg2 = [ psycopg2 ];
    psycopg2-binary = [ psycopg2-binary ];
    psycopg3 = [ psycopg ];
    raft = [
      cryptography
      pysyncobj
    ];
    systemd = [ systemd-python ];
    zookeeper = [ kazoo ];
  };

  pythonImportsCheck = [ "patroni" ];

  nativeCheckInputs =
    (with python3Packages; [
      pytestCheckHook
      versionCheckHook
    ])
    ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests.patroni = nixosTests.patroni;

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/patroni/patroni/blob/${finalAttrs.src.tag}/docs/releases.rst";
    description = "Template for PostgreSQL HA with ZooKeeper, etcd or Consul";
    homepage = "https://patroni.readthedocs.io/en/latest/";
    license = lib.licenses.mit;
    mainProgram = "patroni";
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
    platforms = lib.platforms.unix;
  };
})
