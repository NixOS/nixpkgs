{
  fetchFromGitHub,
  lib,
  localstack,
  python3,
  testers,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "localstack";
  version = "4.9.2";
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

  # Localstack uses a framework called Plux to do all kinds of dynamic code loading.
  # Due to this, we'll encounter build errors when it attempts to set up cache directories
  # in the sandboxed build environment unless we tell it to create it's cache in a safe
  # directory.
  makeWrapperArgs = [
    "--set-default" "XDG_CACHE_HOME" "/tmp/cache"
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
    tests.version = testers.testVersion {
      package = localstack;
      command = "localstack --version";
      inherit version;
    };
  };

  meta = with lib; {
    description = "Fully functional local Cloud stack";
    homepage = "https://github.com/localstack/localstack";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "localstack";
  };
}
