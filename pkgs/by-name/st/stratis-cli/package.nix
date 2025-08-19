{
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "stratis-cli";
  version = "3.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = "stratis-cli";
    tag = "v${version}";
    hash = "sha256-0evuBr3ziiWKkR0FDjZ9BXrfRpQR7JtHsm/sYE8pIbg=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dbus-client-gen
    dbus-python-client-gen
    justbytes
    packaging
    psutil
    python-dateutil
    wcwidth
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests below require dbus daemon
    "tests/whitebox/integration"
  ];

  pythonImportsCheck = [ "stratis_cli" ];

  env.STRATIS_STRICT_POOL_FEATURES = "1"; # required for unit tests

  passthru.tests = nixosTests.stratis;

  meta = with lib; {
    description = "CLI for the Stratis project";
    homepage = "https://stratis-storage.github.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "stratis";
  };
}
