{ lib
, python3Packages
, fetchFromGitHub
, nixosTests
, nix-update-script
}:

python3Packages.buildPythonApplication rec {
  pname = "patroni";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ykTg5Zd4dU1D6dnj6QbNfGUXrSteKrQjV2hpIPhXGLU=";
  };

  propagatedBuildInputs = with python3Packages; [
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

  nativeCheckInputs = with python3Packages; [
    flake8
    mock
    pytestCheckHook
    pytest-cov
    requests
  ];

  # Fix tests by preventing them from writing to /homeless-shelter.
  preCheck = "export HOME=$(mktemp -d)";

  pythonImportsCheck = [ "patroni" ];

  passthru = {
    tests.patroni = nixosTests.patroni;

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://patroni.readthedocs.io/en/latest/";
    description = "Template for PostgreSQL HA with ZooKeeper, etcd or Consul";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = teams.deshaw.members;
  };
}
