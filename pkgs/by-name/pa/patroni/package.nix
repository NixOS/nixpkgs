{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nixosTests,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "patroni";
  version = "4.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = "patroni";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-iY5QLbJXfQtfkzpQxvqSOzYQwgfFsBh8HPYujqxU44k=";
  };

  dependencies = with python3Packages; [
    boto3
    click
    consul
    dnspython
    kazoo
    kubernetes
    prettytable
    psutil
    psycopg2
    pysyncobj
    python-dateutil
    python-etcd
    pyyaml
    tzlocal
    urllib3
    ydiff
  ];

  pythonImportsCheck = [ "patroni" ];

  nativeCheckInputs = with python3Packages; [
    flake8
    mock
    pytestCheckHook
    pytest-cov-stub
    requests
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests.patroni = nixosTests.patroni;

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://patroni.readthedocs.io/en/latest/";
    description = "Template for PostgreSQL HA with ZooKeeper, etcd or Consul";
    changelog = "https://github.com/patroni/patroni/blob/v${finalAttrs.version}/docs/releases.rst";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
