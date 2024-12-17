{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "faraday-agent-dispatcher";
  version = "3.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_agent_dispatcher";
    rev = "refs/tags/${version}";
    hash = "sha256-Qr3ZGU4y7f6yHD78ecdv7a6IBFDpT+/4Yez0n/MenN0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner",' ""
  '';

  pythonRelaxDeps = [
    "python-socketio"
  ];

  build-system = with python3.pkgs; [
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    aiohttp
    click
    faraday-agent-parameters-types
    faraday-plugins
    itsdangerous
    psutil
    pytenable
    python-gvm
    python-owasp-zap-v2-4
    python-socketio
    pyyaml
    requests
    syslog-rfc5424-formatter
    websockets
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  disabledTests = [
    "test_execute_agent"
    "SSL"
  ];

  disabledTestPaths = [
    # Tests require a running Docker instance
    "tests/plugins-docker/test_executors.py"
    "tests/unittests/test_import_official_executors.py"
  ];

  pythonImportsCheck = [
    "faraday_agent_dispatcher"
  ];

  meta = with lib; {
    description = "Tool to send result from tools to the Faraday Platform";
    homepage = "https://github.com/infobyte/faraday_agent_dispatcher";
    changelog = "https://github.com/infobyte/faraday_agent_dispatcher/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "faraday-dispatcher";
  };
}
