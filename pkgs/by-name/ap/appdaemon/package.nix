{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "appdaemon";
  version = "4.5.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AppDaemon";
    repo = "appdaemon";
    tag = finalAttrs.version;
    hash = "sha256-GoKYaMCwfZ8tKsyrNDQN5OeptkAuct90ziXO9MxU2FA=";
  };

  nativeBuildInputs = [
    python3Packages.pyprojectVersionPatchHook
  ];

  build-system = [ python3Packages.uv-build ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-jinja2
    astral
    bcrypt
    feedparser
    paho-mqtt
    pid
    pydantic
    python-dateutil
    python-socketio
    pytz
    pyyaml
    requests
    sockjs
    uvloop
    tomli
    tomli-w
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Sandboxed Python execution environment for writing automation apps for Home Assistant";
    mainProgram = "appdaemon";
    homepage = "https://github.com/AppDaemon/appdaemon";
    changelog = "https://github.com/AppDaemon/appdaemon/blob/${finalAttrs.version}/docs/HISTORY.md";
    license = lib.licenses.mit;
    teams = [ lib.teams.home-assistant ];
  };
})
