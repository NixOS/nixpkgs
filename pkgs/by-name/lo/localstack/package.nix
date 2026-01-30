{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "localstack";
  version = "4.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    tag = "v${version}";
    hash = "sha256-k5aIdfWm3Tvl/J0s1l0gTXJqnb4j5doJdIIaLLOJXg4=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    apispec
    asn1crypto
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

  meta = {
    description = "Fully functional local Cloud stack";
    homepage = "https://github.com/localstack/localstack";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "localstack";
  };
}
