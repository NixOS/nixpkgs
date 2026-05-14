{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "faraday-agent-dispatcher";
  version = "3.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday_agent_dispatcher";
    tag = finalAttrs.version;
    hash = "sha256-uf1oXE8pFvIPTDgcHXRbZDz8NZn9NecPe1eYuYhb1Xw=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail '"pytest-runner",' ""  '';

  pythonRelaxDeps = [
    "python-socketio"
  ];

  pythonRemoveDeps = [
    "python-owasp-zap-v2.4"
  ];

  build-system = with python3.pkgs; [
    setuptools-scm
  ];

  nativeBuildInputs = [
    python3.pkgs.python-owasp-zap-v2-4
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
    requests-ratelimiter
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

  meta = {
    description = "Tool to send result from tools to the Faraday Platform";
    homepage = "https://github.com/infobyte/faraday_agent_dispatcher";
    changelog = "https://github.com/infobyte/faraday_agent_dispatcher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "faraday-dispatcher";
  };
})
