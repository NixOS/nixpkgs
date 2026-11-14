{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "appdaemon";
  version = "4.5.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AppDaemon";
    repo = "appdaemon";
    tag = finalAttrs.version;
    hash = "sha256-eXV2tY91HyfiPCmmB9x4RP5sbBqn+85g3ZhG4Cm3szA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.26,<0.13.0" "uv_build"
  '';

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
