{
  fetchFromGitHub,
  lib,
  localstack,
  nix-update-script,
  python3Packages,
  testers,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "localstack";
  version = "4.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "localstack";
    repo = "localstack";
    tag = "v${version}";
    hash = "sha256-k5aIdfWm3Tvl/J0s1l0gTXJqnb4j5doJdIIaLLOJXg4=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = with python3Packages; [
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

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  # Test suite requires boto, which has been removed from nixpkgs
  # Just do minimal test, buildPythonPackage maps checkPhase
  # to installCheckPhase, so we can test that entrypoint point works.
  checkPhase = ''
    runHook preCheck

    $out/bin/localstack --version

    runHook postCheck
  '';

  # Propagating dependencies leaks them through $PYTHONPATH which causes issues
  # when used in nix-shell.
  postFixup = ''
    rm $out/nix-support/propagated-build-inputs
  '';

  passthru = {
    updateScript = nix-update-script { };

    # Localstack uses a framework called Plux to do all kinds of dynamic code loading.
    # We'll encounter build errors when it attempts to set up cache directories in the
    # sandboxed build/test environment unless we set `XDG_CACHE_HOME` to a writable dir.
    tests.version = testers.testVersion {
      package = localstack;
      command = "XDG_CACHE_HOME=$TMPDIR localstack --version";
      inherit version;
    };
  };

  meta = with lib; {
    description = "Fully functional local Cloud stack";
    homepage = "https://github.com/localstack/localstack";
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ damien ];
    mainProgram = "localstack";
  };
}
