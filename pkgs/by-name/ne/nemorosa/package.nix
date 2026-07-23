{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nemorosa";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyokoMiki";
    repo = "nemorosa";
    tag = finalAttrs.version;
    hash = "sha256-1Heh6iE33IM5SSrXjQMUTOS5xDh+c9nlpzQRNIkUqck=";
  };

  # Upstream uses overly strict, fresh version specifiers
  pythonRelaxDeps = true;

  # `build-system` requirements are seemingly not covered by pythonRelaxDeps
  postPatch = ''
    sed -i 's/requires = \["uv_build.*"\]/requires = ["uv_build"]/' pyproject.toml
  '';

  build-system = with python3Packages; [ uv-build ];

  dependencies =
    with python3Packages;
    [
      aiohttp
      aiolimiter
      anyio
      apprise
      apscheduler
      asyncer
      beautifulsoup4
      defusedxml
      deluge-client
      fastapi
      humanfriendly
      msgspec
      platformdirs
      qbittorrent-api
      reflink-copy
      sqlalchemy
      tenacity
      torf
      transmission-rpc
      uvicorn
      uvloop
    ]
    ++ aiohttp.optional-dependencies.speedups
    ++ beautifulsoup4.optional-dependencies.lxml
    ++ msgspec.optional-dependencies.yaml
    ++ sqlalchemy.optional-dependencies.aiosqlite
    ++ uvicorn.optional-dependencies.standard;

  pythonImportsCheck = [ "nemorosa" ];

  meta = {
    description = "Specialized cross-seeding tool designed for music torrents";
    homepage = "https://github.com/KyokoMiki/nemorosa";
    changelog = "https://github.com/KyokoMiki/nemorosa/releases";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ambroisie ];
    mainProgram = "nemorosa";
  };
})
