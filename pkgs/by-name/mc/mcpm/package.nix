{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcpm";
  version = "1.13.1"; # From src/mcpm/version.py

  src = fetchFromGitHub {
    owner = "pathintegral-institute";
    repo = "mcpm.sh";
    tag = "v${version}";
    hash = "sha256-vIyUaVLjfXY48ALeArs1Gdqo9tOEAkDTv+SeUL9muz0=";
  };

  pyproject = true;

  nativeBuildInputs = with python3Packages; [
    hatchling
    setuptools
    wheel
    pip
  ];

  propagatedBuildInputs = with python3Packages; [
    # Core dependencies from pyproject.toml
    click
    rich
    requests
    pydantic
    duckdb
    psutil
    prompt-toolkit
    deprecated

    # dependencies only available for Python>=3.12 on nixpkgs
    mcp
    ruamel-yaml
    watchfiles

    # Additional dependencies that might be needed
    typer
    httpx
    anyio
    fastapi
    uvicorn
    websockets
    jinja2
    pyyaml
    toml
    python-dotenv
    packaging
    colorama
  ];

  meta = {
    description = "MCPM - Model Context Protocol Manager";
    homepage = "https://mcpm.sh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luochen1990 ];
    mainProgram = "mcpm";
  };
}
