{
  lib,
  python3Packages,
  fetchFromGitHub,
  exabgp,
  testers,
}:

python3Packages.buildPythonApplication rec {
  pname = "exabgp";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Exa-Networks";
    repo = "exabgp";
    tag = version;
    hash = "sha256-UFo92jS/QmwTUEAhxQnbtY9K905jiBrJujfqGIUCUOg=";
  };

  postPatch = ''
    # https://github.com/Exa-Networks/exabgp/pull/1344
    substituteInPlace src/exabgp/application/healthcheck.py --replace-fail \
      "f'/sbin/ip -o address show dev {ifname}'.split()" \
      '["ip", "-o", "address", "show", "dev", ifname]'
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  pythonImportsCheck = [
    "exabgp"
  ];

  nativeCheckInputs = with python3Packages; [
    hypothesis
    psutil
    pytest-asyncio
    pytest-benchmark
    pytest-timeout
    pytest-xdist
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pytestFlags = [ "--benchmark-disable" ];

  enabledTests = [ "tests" ];

  disabledTests = [
    # AssertionError: Server should receive connection
    "test_outgoing_connection_establishment"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = exabgp;
      command = "exabgp version";
    };
  };

  meta = with lib; {
    description = "BGP swiss army knife of networking";
    homepage = "https://github.com/Exa-Networks/exabgp";
    changelog = "https://github.com/Exa-Networks/exabgp/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd3;
    mainProgram = "exabgp";
    maintainers = with maintainers; [
      hexa
      raitobezarius
    ];
  };
}
