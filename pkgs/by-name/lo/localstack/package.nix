{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "localstack";
  version = "4.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    tag = "v${version}";
    hash = "sha256-vyk86iuYI6dGUCtijauwT7p4hSWNXluz5cHHRm8zdOE=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    apispec
    boto3
    build
    cachetools
    click
    cryptography
    localstack-client
    localstack-ext
    plux
    psutil
    python-dotenv
    pyyaml
    packaging
    requests
    rich
    semver
    tailer
  ];

  pythonRelaxDeps = [
    "dill"
  ];

  pythonImportsCheck = [ "localstack" ];

  # Test suite requires boto, which has been removed from nixpkgs
  # Just do minimal test, buildPythonPackage maps checkPhase
  # to installCheckPhase, so we can test that entrypoint point works.
  checkPhase = ''
    runHook preCheck

    export HOME=$(mktemp -d)
    $out/bin/localstack --version

    runHook postCheck
  '';

  # Propagating dependencies leaks them through $PYTHONPATH which causes issues
  # when used in nix-shell.
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  meta = with lib; {
    description = "Fully functional local Cloud stack";
    homepage = "https://github.com/localstack/localstack";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "localstack";
  };
}
