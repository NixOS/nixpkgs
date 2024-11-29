{
  python3Packages,
  lib,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "litestar";
  version = "2.12.1";
  pyproject = true;

  build-system = with python3Packages; [
    hatchling
  ];

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "litestar";
    rev = "refs/tags/v${version}";
    hash = "sha256-bWo+hhSij0H9XGxpqg1/h7O8U8jjTmlaIHfCU5I4RSI=";
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
