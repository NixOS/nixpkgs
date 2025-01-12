{
  python3Packages,
  lib,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "litestar";
  version = "2.13.0";
  pyproject = true;

  build-system = with python3Packages; [
    hatchling
  ];

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "litestar";
    tag = "v${version}";
    hash = "sha256-PR2DVNRtILHs7XwVi9/ZCVRJQFqfGLn1x2gpYtYjHDo=";
  };

  dependencies = with python3Packages; [
    anyio
    click
    redis
    httpx
    msgspec
    multidict
    jinja2
    pyyaml
    rich
    rich-click
    typing-extensions
    psutil
    polyfactory
    litestar-htmx
    trio
    cryptography
    psycopg
    fsspec
    mako
    time-machine
    asyncpg
    picologging
  ];

  meta = {
    homepage = "https://litestar.dev/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/litestar-org/litestar/releases/tag/v${version}";
    description = "Production-ready, Light, Flexible and Extensible ASGI API framework";
    license = lib.licenses.mit;
  };
}
