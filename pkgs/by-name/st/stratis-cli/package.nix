{
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "stratis-cli";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stratis-storage";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-F/RP/bWf2fV1IvNbrkYX3d94om1kACNe+oJI8pXM5P4=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
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

  passthru.tests = nixosTests.stratis;

  meta = with lib; {
    description = "CLI for the Stratis project";
    homepage = "https://stratis-storage.github.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "stratis";
  };
}
