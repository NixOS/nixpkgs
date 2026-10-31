{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  makeWrapper,
  installShellFiles,
}:

python3Packages.buildPythonPackage rec {
  pname = "changeme";
  version = "1.2.3";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ztgrace";
    repo = "changeme";
    rev = "refs/tags/v${version}";
    hash = "sha256-nVHod8xEW05r3ZKfB3OkN2EMGWjfCSA9vOgx+J2OrFI=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    responses
    cerberus
    mock-ssh-server
    jinja2
    logutils
    lxml
    netaddr
    nose
    paramiko
    psycopg2
    pymongo
    pyodbc
    pysnmp
    python-libnmap
    python-memcached
    pyyaml
    redis
    rfc3339-validator
    requests
    selenium
    shodan
    sqlalchemy
    tabulate
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-responses
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    # allow to find the module helper during the test run
    export PYTHONPATH=$PYTHONPATH:$PWD/tests
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/changeme}
    cp -R * $out/share/changeme
    installManPage changeme.1

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    makeWrapper "${python3Packages.python.interpreter}" "$out/bin/changeme" \
      --set PYTHONPATH "$out/share/changeme/changeme.py" \
      --add-flags "$out/share/changeme/changeme.py"

    runHook postFixup
  '';

  meta = {
    description = "Default credential scanner";
    homepage = "https://github.com/ztgrace/changeme";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "changeme";
  };
}
