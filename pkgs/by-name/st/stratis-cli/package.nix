{
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "stratis-cli";
  version = "3.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = "stratis-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZvEjU93h35R6+oDZhQaHfkWrR6d/zVxRcjC33cnbkJI=";
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
    wcwidth
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests below require dbus daemon
    "tests/integration"
  ];

  pythonImportsCheck = [ "stratis_cli" ];

  passthru.tests = nixosTests.stratis;

  meta = {
    description = "CLI for the Stratis project";
    homepage = "https://stratis-storage.github.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "stratis";
  };
})
