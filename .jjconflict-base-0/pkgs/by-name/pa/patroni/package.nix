{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "patroni";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = "patroni";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-if3azfBb6/OegahZYAM2RMxmWRDsCX5DNkUATTcAUrw=";
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
    pytest-cov
    requests
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests.patroni = nixosTests.patroni;

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://patroni.readthedocs.io/en/latest/";
    description = "Template for PostgreSQL HA with ZooKeeper, etcd or Consul";
    changelog = "https://github.com/patroni/patroni/blob/v${version}/docs/releases.rst";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = lib.teams.deshaw.members;
  };
}
