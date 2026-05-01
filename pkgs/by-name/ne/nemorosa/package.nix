{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "nemorosa";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KyokoMiki";
    repo = "nemorosa";
    tag = version;
    hash = "sha256-AqFjpEakEZ21iXmIIxhX+ez2aI/RMsLaUoECipQcaM4=";
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
      aiolimiter
      apscheduler
      beautifulsoup4
      defusedxml
      deluge-client
      fastapi
      httpx
      humanfriendly
      msgspec
      platformdirs
      qbittorrent-api
      reflink-copy
      sqlalchemy
      torf
      transmission-rpc
      uvicorn
      uvloop
    ]
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
}
