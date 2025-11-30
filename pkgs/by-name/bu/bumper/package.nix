{
  fetchFromGitHub,
  lib,
  python3,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "bumper";
  version = "0.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mvladislav";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-gLTK1ZYMSZsq7iSCo1cz/bfKI8s6qcW+4JjwANomNxI=";
  };

  build-systemd = with python3Packages; [ uv-build ];

  dependencies = with python3Packages; [
    aiodns
    aiofiles
    aiohttp-jinja2
    aiohttp
    aiomqtt
    amqtt
    cachetools
    coloredlogs
    cryptography
    defusedxml
    jinja2
    passlib
    pyjwt
    tinydb
    validators
    websockets
  ];

  meta = {
    description = "A standalone and self-hosted implementation of the central server used by Ecovacs vacuum robots.";
    homepage = "https://mvladislav.github.io/bumper";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ananthb ];
    mainProgram = "bumper";
  };
}
