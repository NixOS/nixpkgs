{
  lib,
<<<<<<< HEAD
  python3Packages,
=======
  python3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fetchFromGitHub,
  exabgp,
  testers,
}:

<<<<<<< HEAD
python3Packages.buildPythonApplication rec {
  pname = "exabgp";
  version = "5.0.1";
  pyproject = true;
=======
python3.pkgs.buildPythonApplication rec {
  pname = "exabgp";
  version = "4.2.25";
  format = "pyproject";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Exa-Networks";
    repo = "exabgp";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-UFo92jS/QmwTUEAhxQnbtY9K905jiBrJujfqGIUCUOg=";
  };

  postPatch = ''
    # https://github.com/Exa-Networks/exabgp/pull/1344
    substituteInPlace src/exabgp/application/healthcheck.py --replace-fail \
      "f'/sbin/ip -o address show dev {ifname}'.split()" \
      '["ip", "-o", "address", "show", "dev", ifname]'
  '';

  build-system = with python3Packages; [
=======
    hash = "sha256-YBxRDcm4Qt44W3lBHDwdvZq2pXEujbqJDh24JbXthMg=";
  };

  nativeBuildInputs = with python3.pkgs; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    setuptools
  ];

  pythonImportsCheck = [
    "exabgp"
  ];

<<<<<<< HEAD
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

  meta = {
    description = "BGP swiss army knife of networking";
    homepage = "https://github.com/Exa-Networks/exabgp";
    changelog = "https://github.com/Exa-Networks/exabgp/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    mainProgram = "exabgp";
    maintainers = with lib.maintainers; [
=======
  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = exabgp;
    };
  };

  meta = with lib; {
    description = "BGP swiss army knife of networking";
    homepage = "https://github.com/Exa-Networks/exabgp";
    changelog = "https://github.com/Exa-Networks/exabgp/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd3;
    mainProgram = "exabgp";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      hexa
      raitobezarius
    ];
  };
}
